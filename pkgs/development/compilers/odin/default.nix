{ lib
, fetchFromGitHub
, llvmPackages
, makeWrapper
, libiconv
}:

let
  inherit (llvmPackages) stdenv;
in stdenv.mkDerivation rec {
  pname = "odin";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = "v${version}";
    sha256 = "ke2HPxVtF/Lh74Tv6XbpM9iLBuXLdH1+IE78MAacfYY=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  postPatch = ''
    sed -i 's/^GIT_SHA=.*$/GIT_SHA=/' Makefile
  '';

  dontConfigure = true;

  buildFlags = [
    "release"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp odin $out/bin/odin
    cp -r core $out/bin/core

    wrapProgram $out/bin/odin --prefix PATH : ${lib.makeBinPath (with llvmPackages; [
      bintools
      llvm
      clang
      lld
    ])}
  '';

  meta = with lib; {
    description = "A fast, concise, readable, pragmatic and open sourced programming language";
    homepage = "https://odin-lang.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.x86_64;
  };
}
