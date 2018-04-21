{ stdenv, buildPythonPackage, fetchPypi
, libGLU_combined, xorg, freetype, fontconfig, future}:

buildPythonPackage rec {
  version = "1.3.1";
  pname = "pyglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a73280fa3949ea4890fee28f625c10b1e10a7cda390a08b6bce4740948167cd";
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
