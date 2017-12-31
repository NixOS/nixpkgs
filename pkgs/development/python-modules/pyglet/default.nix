{ stdenv, buildPythonPackage, fetchPypi
, mesa, xorg, freetype, fontconfig, future}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "pyglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "640a8f8e3d7bf8dbb551fa707f14021f619932990ab1401c48ba9dbcc6c2242c";
  };

  postPatch = let
    libs = [ mesa xorg.libX11 freetype fontconfig ];
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
