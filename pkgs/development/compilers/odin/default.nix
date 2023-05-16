{ lib
, fetchFromGitHub
<<<<<<< HEAD
, llvmPackages_13
, makeBinaryWrapper
, libiconv
, MacOSX-SDK
, which
}:

let
  llvmPackages = llvmPackages_13;
  inherit (llvmPackages) stdenv;
in stdenv.mkDerivation rec {
  pname = "odin";
  version = "dev-2023-08";
=======
, llvmPackages
, makeWrapper
, libiconv
}:

let
  inherit (llvmPackages) stdenv;
in stdenv.mkDerivation rec {
  pname = "odin";
  version = "0.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
<<<<<<< HEAD
    rev = version;
    hash = "sha256-pmgrauhB5/JWBkwrAm7tCml9IYQhXyGXsNVDKTntA0M=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper which
=======
    rev = "v${version}";
    sha256 = "ke2HPxVtF/Lh74Tv6XbpM9iLBuXLdH1+IE78MAacfYY=";
  };

  nativeBuildInputs = [
    makeWrapper
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

<<<<<<< HEAD
  LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i src/main.cpp \
      -e 's|-syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk|-syslibroot ${MacOSX-SDK}|'
  '' + ''
    sed -i build_odin.sh \
      -e 's/^GIT_SHA=.*$/GIT_SHA=/' \
      -e 's/LLVM-C/LLVM/' \
      -e 's/framework System/lSystem/'
    patchShebangs build_odin.sh
=======
  postPatch = ''
    sed -i 's/^GIT_SHA=.*$/GIT_SHA=/' Makefile
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  dontConfigure = true;

  buildFlags = [
    "release"
  ];

  installPhase = ''
<<<<<<< HEAD
    runHook preInstall

    mkdir -p $out/bin
    cp odin $out/bin/odin

    mkdir -p $out/share
    cp -r core $out/share/core
    cp -r vendor $out/share/vendor

    wrapProgram $out/bin/odin \
      --prefix PATH : ${lib.makeBinPath (with llvmPackages; [
        bintools
        llvm
        clang
        lld
      ])} \
      --set-default ODIN_ROOT $out/share

    runHook postInstall
=======
    mkdir -p $out/bin
    cp odin $out/bin/odin
    cp -r core $out/bin/core

    wrapProgram $out/bin/odin --prefix PATH : ${lib.makeBinPath (with llvmPackages; [
      bintools
      llvm
      clang
      lld
    ])}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "A fast, concise, readable, pragmatic and open sourced programming language";
    homepage = "https://odin-lang.org/";
<<<<<<< HEAD
    license = licenses.bsd3;
    maintainers = with maintainers; [ luc65r astavie ];
    platforms = platforms.x86_64 ++ [ "aarch64-darwin" ];
=======
    license = licenses.bsd2;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.x86_64;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
