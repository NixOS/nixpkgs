{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c1lm3i4yngi1qclb0hny19vwjd2si5k2qni30wcrnxqqasqak1y";
  };

  meta = {
    description = "A library to choose unique available network ports.";
    homepage = https://github.com/google/python_portpicker;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danharaj ];
  };
}
