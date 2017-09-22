{ stdenv, buildPythonPackage, fetchFromGitHub
, boost, freetype, ftgl, mesa }:

buildPythonPackage rec {
  name = "pyftgl-0.4b";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "pyftgl";
    rev = "0.4b";
    sha256 = "12zcjv4cwwjihiaf74kslrdmmk4bs47h7006gyqfwdfchfjdgg4r";
  };

  buildInputs = [ boost freetype ftgl mesa ];

  meta = with stdenv.lib; {
    description = "Python bindings for FTGL (FreeType for OpenGL)";
    license = licenses.gpl2Plus;
  };
}
