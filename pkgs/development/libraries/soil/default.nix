{ stdenv, fetchurl, unzip, mesa, libX11, libGL }:

stdenv.mkDerivation {
  name = "soil";

  src = fetchurl {
    url    = "http://www.lonesock.net/files/soil.zip";
    sha256 = "00gpwp9dldzhsdhksjvmbhsd2ialraqbv6v6dpikdmpncj6mnc52";
  };

  buildInputs = [ unzip mesa libGL libX11 ];

  sourceRoot = "Simple OpenGL Image Library/projects/makefile";
  preBuild   = "mkdir obj";
  preInstall = "mkdir -p $out/lib $out/include";
  makeFlags  = [ "LOCAL=$(out)" ];

  meta = {
    description     = "Simple OpenGL Image Library";
    longDescription = ''
      SOIL is a tiny C library used primarily for uploading textures
      into OpenGL.
    '';
    homepage  = "https://www.lonesock.net/soil.html";
    license   = stdenv.lib.licenses.publicDomain;
    platforms = stdenv.lib.platforms.linux;
  };
}
