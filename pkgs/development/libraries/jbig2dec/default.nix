{ lib, stdenv, fetchurl, python3, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "jbig2dec";
  version = "0.19";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9533/${pname}-${version}.tar.gz";
    sha256 = "0dwa24kjqyg9hmm40fh048sdxfpnasz43l2rm8wlkw1qbdlpd517";
  };

  postPatch = ''
    patchShebangs test_jbig2dec.py
  '';

  nativeBuildInputs = [ autoreconfHook ];

  nativeCheckInputs = [ python3 ];
  doCheck = true;

  meta = {
    homepage = "https://www.jbig2dec.com/";
    description = "Decoder implementation of the JBIG2 image compression format";
    license = lib.licenses.agpl3;
    platforms = lib.platforms.unix;
  };
}
