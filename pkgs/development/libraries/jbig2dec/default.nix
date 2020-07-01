{ stdenv, fetchurl, python3, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "jbig2dec";
  version = "0.18";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs952/${pname}-${version}.tar.gz";
    sha256 = "0pigfw2v0ppvr0lbysm69gx0zsa5q2q92yrb8af2j3im6x97f6cy";
  };

  postPatch = ''
    patchShebangs test_jbig2dec.py
  '';

  buildInputs = [ autoreconfHook ];

  checkInputs = [ python3 ];
  doCheck = true;

  meta = {
    homepage = "https://www.jbig2dec.com/";
    description = "Decoder implementation of the JBIG2 image compression format";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
