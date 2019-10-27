{ stdenv, fetchurl, python, autoconf }:

stdenv.mkDerivation rec {
  name = "jbig2dec-0.16";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs927/${name}.tar.gz";
    sha256 = "00h61y7bh3z6mqfzxyb318gyh0f8jwarg4hvlrm83rqps8avzxm4";
  };

  postPatch = ''
    patchShebangs test_jbig2dec.py
  '';

  buildInputs = [ autoconf ];

  checkInputs = [ python ];
  doCheck = true;

  meta = {
    homepage = https://www.jbig2dec.com/;
    description = "Decoder implementation of the JBIG2 image compression format";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
