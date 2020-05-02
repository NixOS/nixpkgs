{ stdenv
, lib
, fetchurl
, buildPythonPackage
, mock
, fetchPypi
, wheel
, python
, symlinkJoin
}:


buildPythonPackage rec {
  pname = "ray";
  version = "0.8.4";
  format = "wheel";

  src = fetchPypi {
    inherit pname version wheel;
    sha256 = "1pzgj85c6g8vr3dq215cd1y2pn8pxc6wa7mjd9m0zrglr1qwwhdz";
    python = "cp37";
    platform = "manylinux1_x86_64";

  };

  meta = with stdenv.lib; {
    description = "A system for parallel and distributed Python that unifies the ML ecosystem.";
    homepage = https://ray.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ mjlbach ];
    platforms = [ "x86_64-linux" ];
  };
}
