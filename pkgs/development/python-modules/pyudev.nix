{ lib, fetchurl, buildPythonPackage
, six, systemd
}:

buildPythonPackage rec {
  name = "pyudev-${version}";
  version = "0.21.0";

  src = fetchurl {
    url = "mirror://pypi/p/pyudev/${name}.tar.gz";
    sha256 = "0arz0dqp75sszsmgm6vhg92n1lsx91ihddx3m944f4ah0487ljq9";
  };

  postPatch = ''
    substituteInPlace src/pyudev/_ctypeslib/libudev.py \
      --replace "find_library('udev')" "'${systemd.lib}/lib/libudev.so'"
    '';

  propagatedBuildInputs = [ systemd six ];

  meta = {
    homepage = "http://pyudev.readthedocs.org/";
    description = "Pure Python libudev binding";
    license = lib.licenses.lgpl21Plus;
  };
}
