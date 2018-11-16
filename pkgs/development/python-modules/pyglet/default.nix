{ stdenv, buildPythonPackage, fetchPypi
, libGLU_combined, xorg, freetype, fontconfig, future}:

buildPythonPackage rec {
  version = "1.3.2";
  pname = "pyglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b00570e7cdf6971af8953b6ece50d83d13272afa5d1f1197c58c0f478dd17743";
  };

  postPatch = let
    libs = [ libGLU_combined xorg.libX11 freetype fontconfig ];
    paths = builtins.concatStringsSep "," (map (l: "\"${l}/lib\"") libs);
  in "sed -i -e 's|directories\.extend.*lib[^]]*|&,${paths}|' pyglet/lib.py";

  doCheck = false;

  propagatedBuildInputs = [ future ];

  meta = with stdenv.lib; {
    homepage = "http://www.pyglet.org/";
    description = "A cross-platform windowing and multimedia library";
    license = licenses.bsd3;
    platforms = platforms.mesaPlatforms;
  };
}
