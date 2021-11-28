{ lib, stdenv, fetchFromGitHub, nodejs, python }:

stdenv.mkDerivation rec {
  pname = "ueforth";
  version = "unstable-2021-09-20";
  src = fetchFromGitHub {
    owner = "flagxor";
    repo = "eforth";
    rev = "830e6b40d7d3a4c67302c65359c4989e2ff5a5de";
    sha256 = "0xc5s3vyq3h5xjkvdxrq3fklg6pq1xsq7gy1p7aih937x4vcrlgh";
  };

  postUnpack = ''
    sourceRoot=$sourceRoot/ueforth
  '';

  postPatch = ''
    sed -i 's_/usr/bin/env nodejs_${nodejs}/bin/node_' **/*.js
    sed -i 's_/usr/bin/env python_${python}/bin/python_' **/*.py
  '';

  buildPhase = ''
    make "REVISION=${src.rev}" out/posix/ueforth
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/ueforth
    cp out/posix/ueforth $out/bin
    cp -R common posix $out/share/ueforth/
  '';

  meta = {
    description = "µEforth, an EForth inspired Forth bootstraped from a minimalist C kernel";
    homepage = "https://github.com/flagxor/eforth/tree/main/ueforth";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };

}
