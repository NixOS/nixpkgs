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
, fetchMavenArtifact
, fetchgit
, fetchFromGitHub
, makeWrapper
, runCommand }:

stdenv.mkDerivation rec {
  pname = "nbb";
  version = "0.5.104";

  src = fetchFromGitHub {
    owner = "babashka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OCcX3WcbhllQJFlr6lM46H0194JYuhOljdmuc3TG6WA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ babashka cacert git jdk nodejs clojure ];
  GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt";
  SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt";
  buildPhase = ''
    runHook preBuild
    export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    mkdir -p .m2
    substituteInPlace deps.edn --replace ':paths' ':mvn/local-repo "./.m2" :paths'
    substituteInPlace bb.edn --replace ':paths' ':mvn/local-repo "./.m2" :paths'
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

  installPhase = let
    classp  = (import ./deps.nix { inherit fetchMavenArtifact fetchgit lib; }).makeClasspaths {};
  in ''
    runHook preInstall

    makeWrapper '${nodejs}/bin/node' "$out/bin/nbb" \
    --add-flags "$out/lib/nbb_main.js" \
    --add-flags "--classpath ${classp}"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
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
