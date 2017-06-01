{ lib, fetchurl, buildPythonPackage
, six, systemd, pytest, mock, hypothesis, docutils
}:

buildPythonPackage rec {
  pname = "pyudev";
  name = "${pname}-${version}";
  version = "0.21.0";

  src = fetchurl {
    url = "mirror://pypi/p/pyudev/${name}.tar.gz";
    sha256 = "0arz0dqp75sszsmgm6vhg92n1lsx91ihddx3m944f4ah0487ljq9";
  };

  postPatch = ''
    substituteInPlace src/pyudev/_ctypeslib/utils.py \
      --replace "find_library(name)" "'${systemd.lib}/lib/libudev.so'"
    '';

  buildInputs = [ pytest mock hypothesis docutils ];
  propagatedBuildInputs = [ systemd six ];

  checkPhase = ''
    py.test
  '';

  # Bunch of failing tests
  # https://github.com/pyudev/pyudev/issues/187
  doCheck = false;

  meta = {
    homepage = "http://pyudev.readthedocs.org/";
    description = "Pure Python libudev binding";
    license = lib.licenses.lgpl21Plus;
  };
}
