{ lib
, stdenv
, fetchurl
, babashka
, cacert
, clojure
, git
, jdk
, callPackage
, makeWrapper
, runCommand }:

stdenv.mkDerivation rec {
  pname = "obb";
  version = "0.0.1";

  src = fetchurl {
    url = "https://github.com/babashka/${pname}/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-ZVd3VCJ7vdQGQ7iY5v2b+gRX/Ni0/03hzqBElqpPvpI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ babashka cacert git jdk ];

  configurePhase = ''
    runHook preConfigure

    mkdir -p .m2
    substituteInPlace deps.edn --replace ':paths' ':mvn/local-repo "./.m2" :paths'
    substituteInPlace bb.edn --replace ':paths' ':mvn/local-repo "./.m2" :paths'
    echo deps.edn

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export DEPS_CLJ_TOOLS_DIR=${clojure}
    export DEPS_CLJ_TOOLS_VERSION=${clojure.version}
    mkdir -p .gitlibs
    mkdir -p .cpcache
    export GITLIBS=.gitlibs
    export CLJ_CACHE=.cpcache

    bb build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s /usr/bin/osascript $out/bin/osascript

    install -Dm755 "out/bin/obb" "$out/bin/obb"
    wrapProgram $out/bin/obb --prefix PATH : $out/bin

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    [ $($out/bin/obb -e '(+ 1 2)') = '3' ]
  '';


  meta = with lib; {
    description = "Ad-hoc ClojureScript scripting of Mac applications via Apple's Open Scripting Architecture";
    homepage = "https://github.com/babashka/obb";
    license = licenses.epl10;
    maintainers = with maintainers; [
      willcohen
    ];
    platforms = platforms.darwin;
  };
}
