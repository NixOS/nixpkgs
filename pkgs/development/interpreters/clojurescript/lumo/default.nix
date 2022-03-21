{ stdenv
, lib
, fetchurl
, clojure
, gnutar
, nodejs
, jre
, unzip
, nodePackages
, xcbuild
, python2
, openssl
, pkgs
, fetchgit
, darwin
}:
let
  version = "1.10.1";
  nodeVersion = "11.13.0";
  nodeSources = fetchurl {
    url = "https://nodejs.org/dist/v${nodeVersion}/node-v${nodeVersion}.tar.gz";
    sha256 = "1cjzjbshxnysxkvbf41p3m8298cnhs9kfvdczgvvvlp6w16x4aac";
  };
  lumo-internal-classpath = "LUMO__INTERNAL__CLASSPATH";

  # as found in cljs/snapshot/lumo/repl.cljs
  requireDeps = '' \
      cljs.analyzer \
      cljs.compiler \
      cljs.env \
      cljs.js \
      cljs.reader \
      cljs.repl \
      cljs.source-map \
      cljs.source-map.base64 \
      cljs.source-map.base64-vlq \
      cljs.spec.alpha \
      cljs.spec.gen.alpha \
      cljs.tagged-literals \
      cljs.tools.reader \
      cljs.tools.reader.reader-types \
      cljs.tools.reader.impl.commons \
      cljs.tools.reader.impl.utils \
      clojure.core.rrb-vector \
      clojure.core.rrb-vector.interop \
      clojure.core.rrb-vector.nodes \
      clojure.core.rrb-vector.protocols \
      clojure.core.rrb-vector.rrbt \
      clojure.core.rrb-vector.transients \
      clojure.core.rrb-vector.trees \
      clojure.string \
      clojure.set \
      clojure.walk \
      cognitect.transit \
      fipp.visit \
      fipp.engine \
      fipp.deque \
      lazy-map.core \
      lumo.pprint.data \
      lumo.repl \
      lumo.repl-resources \
      lumo.js-deps \
      lumo.common '';

  compileClojurescript = (simple: ''
    (require '[cljs.build.api :as cljs])
    (cljs/build \"src/cljs/snapshot\"
      {:optimizations      ${if simple then ":simple" else ":none"}
       :main               'lumo.core
       :cache-analysis     true
       :source-map         false
       :dump-core          false
       :static-fns         true
       :optimize-constants false
       :npm-deps           false
       :verbose            true
       :closure-defines    {'cljs.core/*target*       \"nodejs\"
                            'lumo.core/*lumo-version* \"${version}\"}
       :compiler-stats     true
       :process-shim       false
       :fn-invoke-direct   true
       :parallel-build     false
       :browser-repl       false
       :target             :nodejs
       :hashbang           false
       ;; :libs               [ \"src/cljs/bundled\" \"src/js\" ]
       :output-dir         ${if simple
  then ''\"cljstmp\"''
  else ''\"target\"''}
       :output-to          ${if simple
  then ''\"cljstmp/main.js\"''
  else ''\"target/deleteme.js\"'' }})
  ''
  );


  cacheToJsons = ''
    (import [java.io ByteArrayOutputStream FileInputStream])
    (require '[cognitect.transit :as transit]
             '[clojure.edn :as edn]
             '[clojure.string :as str])

    (defn write-transit-json [cache]
      (let [out (ByteArrayOutputStream. 1000000)
            writer (transit/writer out :json)]
        (transit/write writer cache)
        (.toString out)))

    (defn process-caches []
      (let [cache-aot-path      \"target/cljs/core.cljs.cache.aot.edn\"
            cache-aot-edn       (edn/read-string (slurp cache-aot-path))
            cache-macros-path   \"target/cljs/core\$macros.cljc.cache.json\"
            cache-macros-stream (FileInputStream. cache-macros-path)
            cache-macros-edn    (transit/read (transit/reader cache-macros-stream :json))
            caches              [[cache-aot-path cache-aot-edn]
                                 [cache-macros-path cache-macros-edn]]]
        (doseq [[path cache-edn] caches]
          (doseq [key (keys cache-edn)]
            (let [out-path (str/replace path #\"(\.json|\.edn)\$\"
                             (str \".\" (munge key) \".json\"))
                  tr-json  (write-transit-json (key cache-edn))]
              (spit out-path tr-json))))))

    (process-caches)
  '';

  trimMainJsEnd = ''
    (let [string (slurp \"target/main.js\")]
      (spit \"target/main.js\"
        (subs string  0 (.indexOf string \"cljs.nodejs={};\"))))
  '';


  cljdeps = import ./deps.nix { inherit pkgs; };
  classp = cljdeps.makeClasspaths {
    extraClasspaths = [ "src/js" "src/cljs/bundled" "src/cljs/snapshot" ];
  };


  getJarPath = jarName: (lib.findFirst (p: p.name == jarName) null cljdeps.packages).path.jar;
in
stdenv.mkDerivation {
  inherit version;
  pname = "lumo";

  src = fetchgit {
    url = "https://github.com/anmonteiro/lumo.git";
    rev = version;
    sha256 = "12agi6bacqic2wq6q3l28283badzamspajmajzqm7fbdl2aq1a4p";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    nodejs
    clojure
    jre
    python2
    openssl
    gnutar
    nodePackages."lumo-build-deps-../interpreters/clojurescript/lumo"
  ]
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices
    xcbuild
  ]
  );

  patches = [ ./no_mangle.patch ./mkdir_promise.patch ];

  postPatch = ''
    substituteInPlace $NIX_BUILD_TOP/lumo/vendor/nexe/exe.js \
      --replace 'glob.sync(dir + "/*")' 'glob.sync(dir + "/../*")'
  '';

  buildPhase = ''
       # Copy over lumo-build-deps environment
    rm yarn.lock
    cp -rf ${nodePackages."lumo-build-deps-../interpreters/clojurescript/lumo"}/lib/node_modules/lumo-build-deps/* ./

    # configure clojure-cli
    mkdir ./.cpcache
    export CLJ_CONFIG=`pwd`
    export CLJ_CACHE=`pwd`/.cpcache

    # require more namespaces for cljs-bundle
    sed -i "s!ns lumo.core! \
              ns lumo.core  \
               (:require ${requireDeps}) \
               (:require-macros [clojure.template :as temp] \
                                [cljs.test :as test])!g" \
              ./src/cljs/snapshot/lumo/core.cljs

    # Step 1: compile clojurescript with :none and :simple
    ${clojure}/bin/clojure -Scp ${classp} -e "${compileClojurescript true}"
    ${clojure}/bin/clojure -Scp ${classp} -e "${compileClojurescript false}"
    cp -f cljstmp/main.js target/main.js
    ${clojure}/bin/clojure -Scp ${classp} -e "${trimMainJsEnd}"

    # Step 2: sift files
    unzip -o ${getJarPath "org.clojure/clojurescript"} -d ./target
    unzip -j ${getJarPath "org.clojure/clojure"} "clojure/template.clj" -d ./target/clojure
    unzip -o ${getJarPath "org.clojure/google-closure-library"} -d ./target
    unzip -o ${getJarPath "org.clojure/google-closure-library-third-party"} -d ./target
    unzip -o ${getJarPath "org.clojure/tools.reader"} -d ./target
    unzip -o ${getJarPath "org.clojure/test.check"} -d ./target
    cp -rf ./src/cljs/bundled/lumo/* ./target/lumo/
    cp -rf ./src/cljs/snapshot/lumo/repl.clj ./target/lumo/
    # cleanup
    mv ./target/main.js ./target/main
    rm ./target/*\.js
    mv ./target/main ./target/main.js
    rm ./target/AUTHORS
    rm ./target/LICENSE
    rm ./target/*.edn
    rm ./target/*.md
    rm -rf ./target/css
    rm -rf ./target/META-INF
    rm -rf ./target/com
    rm -rf ./target/cljs/build
    rm -rf ./target/cljs/repl
    rm  ./target/cljs/core\.cljs\.cache.aot\.json
    rm  ./target/cljs/source_map\.clj
    rm  ./target/cljs/repl\.cljc
    rm  ./target/cljs/externs\.clj
    rm  ./target/cljs/closure\.clj
    rm  ./target/cljs/util\.cljc
    rm  ./target/cljs/js_deps\.cljc
    rm  ./target/cljs/analyzer/utils\.clj
    rm  ./target/cljs/core/macros\.clj
    rm  ./target/cljs/compiler/api.clj
    rm  ./target/goog/test_module*
    rm  ./target/goog/transpile\.js
    rm  ./target/goog/base_*
    find ./target -type f -name '*.class' -delete
    find ./target -type d -empty -delete

    # Step 3: generate munged cache jsons
    ${clojure}/bin/clojure -Scp ${classp} -e "${cacheToJsons}"
    rm  ./target/cljs/core\$macros\.cljc\.cache\.json


    # Step 4: Bunde javascript
    NODE_ENV=production node scripts/bundle.js
    node scripts/bundleForeign.js

    # Step 5: Backup resources
    cp -R target resources_bak

    # Step 6: Package executeable 1st time
    # fetch node sources and copy to palce that nexe will find
    mkdir -p tmp/node/${nodeVersion}
    cp ${nodeSources} tmp/node/${nodeVersion}/node-${nodeVersion}.tar.gz
    tar -C ./tmp/node/${nodeVersion} -xf ${nodeSources} --warning=no-unknown-keyword
    mv ./tmp/node/${nodeVersion}/node-v${nodeVersion}/* ./tmp/node/${nodeVersion}/
    rm -rf ${lumo-internal-classpath}
    cp -rf target ${lumo-internal-classpath}
    node scripts/package.js ${nodeVersion}
    rm -rf target
    mv ${lumo-internal-classpath} target

    # Step 7: AOT Macros
    sh scripts/aot-bundle-macros.sh

    # Step 8: Package executeable 2nd time
    node scripts/package.js ${nodeVersion}
  '';

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp build/lumo $out/bin
  '';

  meta = {
    description = "Fast, cross-platform, standalone ClojureScript environment";
    longDescription = ''
      Lumo is a fast, standalone ClojureScript REPL that runs on Node.js and V8.
      Thanks to V8's custom startup snapshots, Lumo starts up instantaneously,
      making it the fastest Clojure REPL in existence.
    '';
    homepage = "https://github.com/anmonteiro/lumo";
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.hlolli ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
