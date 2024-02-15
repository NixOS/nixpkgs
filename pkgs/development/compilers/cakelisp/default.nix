{ lib, stdenv, fetchgit, gcc }:

stdenv.mkDerivation rec {
  pname = "cakelisp";
  version = "0.1.0";

  src = fetchgit {
    url = "https://macoy.me/code/macoy/cakelisp";
    rev = "v${version}";
    sha256 = "sha256-r7Yg8+2U8qQTYRP3KFET7oBRCZHIZS6Y8TsfL1NR24g=";
  };

  buildInputs = [ gcc ];

  postPatch = ''
    substituteInPlace runtime/HotReloading.cake \
        --replace '"/usr/bin/g++"' '"${gcc}/bin/g++"'
    substituteInPlace src/ModuleManager.cpp \
        --replace '"/usr/bin/g++"' '"${gcc}/bin/g++"'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Build.sh --replace '--export-dynamic' '-export_dynamic'
    substituteInPlace runtime/HotReloading.cake --replace '--export-dynamic' '-export_dynamic'
    substituteInPlace Bootstrap.cake --replace '--export-dynamic' '-export_dynamic'
  '';

  buildPhase = ''
    runHook preBuild
    ./Build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/cakelisp -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "A performance-oriented Lisp-like language";
    homepage = "https://macoy.me/code/macoy/cakelisp";
    license = licenses.gpl3Plus;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = [ maintainers.sbond75 ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
