{ lib
, stdenv
, fetchurl
, babashka
, cacert
, clojure
, git
, jdk
, nbb
, nodejs
, fetchFromGitHub
, makeWrapper
, runCommand }:

stdenv.mkDerivation rec {
  pname = "nbb";
  version = "0.5.103";

  src = fetchFromGitHub {
    owner = "babashka";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hlpn83mmjvc4n7zkqlcbdjjm8v3qs1q56ywgsg0snqdqayw11yf";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ babashka cacert git jdk nodejs clojure ];

  configurePhase = ''
    runHook preConfigure

    mkdir -p .m2
    substituteInPlace deps.edn --replace ':paths' ':mvn/local-repo "./.m2" :paths'
    substituteInPlace bb.edn --replace ':paths' ':mvn/local-repo "./.m2" :paths'

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export DEPS_CLJ_TOOLS_DIR=${clojure}
    export DEPS_CLJ_TOOLS_VERSION=${clojure.version}
    mkdir .cpcache .gitlibs
    export GITLIBS=.gitlibs
    export CLJ_CACHE=.cpcache

    mkdir -pv $out/bin
    bb release
    cp -rf ./* $out/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    makeWrapper '${nodejs}/bin/node' "$out/bin/nbb" \
    --add-flags "$out/lib/nbb_main.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/nbb --help > /dev/null
    [ $($out/bin/nbb -e '(+ 1 2)') = '3' ]
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Not babashka. Node.js babashka!? Ad-hoc CLJS scripting on Node.js.";
    homepage = "https://github.com/babashka/nbb";
    license = licenses.epl10;
    maintainers = with maintainers; [
      PlumpMath
    ];
    platforms = platforms.unix;
  };
}
