{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "libeatmydata-105";
  
  src = fetchurl {
    url = "http://www.flamingspork.com/projects/libeatmydata/${name}.tar.gz";
    sha256 = "1pd8sc73cgc41ldsvq6g8ics1m5k8gdcb91as9yg8z5jnrld1lmx";
  };

  buildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/eatmydata \
      --prefix PATH : $out/bin
  '';

  meta = {
    homepage = https://www.flamingspork.com/projects/libeatmydata/;
    license = stdenv.lib.licenses.gpl3Plus;
    description = "Small LD_PRELOAD library to disable fsync and friends";
    platforms = stdenv.lib.platforms.unix;
  };
}
