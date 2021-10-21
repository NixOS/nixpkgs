{ lib, stdenv, fetchFromGitHub
, nodejs, python
}:
let
  REVISION = "830e6b40d7d3a4c67302c65359c4989e2ff5a5de";
in stdenv.mkDerivation {
  name = "ueforth";
  inherit REVISION;
  src = fetchFromGitHub {
    owner = "flagxor";
    repo = "eforth";
    rev = REVISION;
    sha256 = "0xc5s3vyq3h5xjkvdxrq3fklg6pq1xsq7gy1p7aih937x4vcrlgh";
  };

  postUnpack = ''
    sourceRoot=$sourceRoot/ueforth
  '';

  patchPhase = ''
    sed -i 's_/usr/bin/env nodejs_${nodejs}/bin/node_' **/*.js
    sed -i 's_/usr/bin/env python_${python}/bin/python_' **/*.py
  '';

  buildPhase = ''
    make "REVISION=$REVISION" out/posix/ueforth
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
