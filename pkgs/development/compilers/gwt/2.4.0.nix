{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "gwt-java-2.4.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/google-web-toolkit/gwt-2.4.0.zip";
    sha256 = "1gvyg00vx7fdqgfl2w7nhql78clg3abs6fxxy7m03pprdm5qmm17";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out
    unzip $src
    mv gwt-2.4.0 $out/bin
  '';

  meta = {
    homepage = http://www.gwtproject.org/;
    description = "A development toolkit for building and optimizing complex browser-based applications";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
