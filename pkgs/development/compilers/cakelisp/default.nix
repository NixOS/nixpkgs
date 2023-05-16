<<<<<<< HEAD
{ lib, stdenv, fetchgit, gcc }:
=======
{ lib, stdenv, fetchFromGitHub, gcc }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "cakelisp";
  version = "0.1.0";

<<<<<<< HEAD
  src = fetchgit {
    url = "https://macoy.me/code/macoy/cakelisp";
    rev = "v${version}";
    sha256 = "sha256-r7Yg8+2U8qQTYRP3KFET7oBRCZHIZS6Y8TsfL1NR24g=";
=======
  src = fetchFromGitHub {
    owner = "makuto";
    repo = "cakelisp";
    rev = "v${version}";
    sha256 = "126va59jy7rvy6c2wrf8j44m307f2d8jixqkc49s9wllxprj1dmg";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    runHook preBuild
    ./Build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/cakelisp -t $out/bin
    runHook postInstall
=======
    ./Build.sh
  '';

  installPhase = ''
    install -Dm755 bin/cakelisp -t $out/bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "A performance-oriented Lisp-like language";
<<<<<<< HEAD
    homepage = "https://macoy.me/code/macoy/cakelisp";
=======
    homepage = "https://github.com/makuto/cakelisp";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = [ maintainers.sbond75 ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
