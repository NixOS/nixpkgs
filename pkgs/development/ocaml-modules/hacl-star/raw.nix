{ lib, which, stdenv, fetchFromGitHub, ocaml, findlib, hacl-star, ctypes, cppo }:

stdenv.mkDerivation rec {
  pname = "hacl-star-raw";
  version = "0.3.2";

  /*
    I can't get this to work since they publish a built, tarball
    src = fetchFromGitHub {
    owner = "project-everest";
    repo = "hacl-star";
    rev = "ocaml-v${version}";
    sha256 = "1pg7fyvjx6gyf4819kxspc1f0w530c5mqmlp1jy2h80bl8aaa83s";
    };
  */

  src = builtins.fetchurl {
    url = "https://github.com/project-everest/hacl-star/releases/download/ocaml-v${version}/hacl-star.${version}.tar.gz";
    sha256 = "0iybh7nnxyf4r97px2154a2p534cxvlwxgrzi5lq7hh5mpvx6ykb";
  };
  sourceRoot = ".";

  postPatch = ''
    patchShebangs ./raw
  '';

  configurePhase = ''
    cd raw
    ./configure
    cd ..
  '';

  buildPhase = ''
    make -C raw
  '';

  buildInputs = [
    which
    ocaml
    findlib
  ];

  propagatedBuildInputs = [
    ctypes
  ];

  checkInputs = [
    cppo
  ];

  doCheck = true;

  installPhase = ''
    make -C raw install-hacl-star-raw
  '';

  createFindlibDestdir = true;

  meta = {
    description = "Auto-generated low-level OCaml bindings for EverCrypt/HACL*";
    license = lib.licenses.asl20;
    maintainers = lib.maintaners.ulrikstrid;
  };
}
