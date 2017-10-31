{ stdenv, buildPythonPackage, fetchPypi
, mesa, xorg, freetype, fontconfig}:

buildPythonPackage rec {
  version = "1.2.4";
  pname = "pyglet";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f62ffbbcf2b202d084bf158685e77d28b8f4f5f2738f4c5e63a947a07503445";
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
