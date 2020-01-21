{ stdenv, fetchurl, python3, autoconf }:

stdenv.mkDerivation rec {
  name = "jbig2dec-0.17";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs950/${name}.tar.gz";
    sha256 = "0wpvslmwazia3z8gyk343kbq6yj47pxr4x5yjvx332v309qssazp";
  };

  postPatch = ''
    patchShebangs test_jbig2dec.py
  '';

  buildInputs = [ autoconf ];

  checkInputs = [ python3 ];
  doCheck = true;

  meta = {
    homepage = https://www.jbig2dec.com/;
    description = "Decoder implementation of the JBIG2 image compression format";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
