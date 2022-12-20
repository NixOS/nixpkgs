{ lib, stdenv, fetchFromGitHub, gcc }:

stdenv.mkDerivation rec {
  pname = "cakelisp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "makuto";
    repo = "cakelisp";
    rev = "v${version}";
    sha256 = "126va59jy7rvy6c2wrf8j44m307f2d8jixqkc49s9wllxprj1dmg";
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
    ./Build.sh
  '';

  installPhase = ''
    install -Dm755 bin/cakelisp -t $out/bin
  '';

  meta = with lib; {
    description = "A performance-oriented Lisp-like language";
    homepage = "https://github.com/makuto/cakelisp";
    license = licenses.gpl3Plus;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = [ maintainers.sbond75 ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
