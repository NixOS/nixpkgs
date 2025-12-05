{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "wavrsocvt";
  version = "1.0.2.0";

  src = fetchurl {
    url = "https://bricxcc.sourceforge.net/wavrsocvt.tgz";
    sha256 = "15qlvdfwbiclljj7075ycm78yzqahzrgl4ky8pymix5179acm05h";
  };

  unpackPhase = ''
    tar -zxf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp wavrsocvt $out/bin
  '';

  meta = with lib; {
    description = "Convert .wav files into sound files for Lego NXT brick";
    mainProgram = "wavrsocvt";
    longDescription = ''
      wavrsocvt is a command-line utility which can be used from a
      terminal window or script to convert .wav files into sound
      files for the NXT brick (.rso files). It can also convert the
      other direction (i.e., .rso -> .wav). It can produce RSO files
      with a sample rate between 2000 and 16000 (the min/max range of
      supported sample rates in the standard NXT firmware).
      You can then upload these with e.g. nxt-python.
    '';
    homepage = "https://bricxcc.sourceforge.net/";
    license = licenses.mpl11;
    platforms = with platforms; linux;
  };
}
