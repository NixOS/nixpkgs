{ stdenv, buildPythonPackage, fetchPypi
, mesa, xorg, freetype, fontconfig}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "pyglet";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "640a8f8e3d7bf8dbb551fa707f14021f619932990ab1401c48ba9dbcc6c2242c";
  };

  patchPhase = let
    libs = [ mesa xorg.libX11 freetype fontconfig ];
    paths = builtins.concatStringsSep "," (map (l: "\"${l}/lib\"") libs);
  in "sed -i -e 's|directories\.extend.*lib[^]]*|&,${paths}|' pyglet/lib.py";

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://www.pyglet.org/";
    description = "A cross-platform windowing and multimedia library";
    license = licenses.bsd3;
    platforms = platforms.mesaPlatforms;
  };
}
