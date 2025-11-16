{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyvisa
}:

buildPythonPackage rec {
  pname = "rsinstrument";
  version = "1.53.1";

  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "RsInstrument";
    inherit version;
    hash = "sha256-QlbaQUlh1U8GhgP9bGKqQdTyzF0gb+dOMWws8Uqji+8=";
  };

  propagatedBuildInputs = [ pyvisa ];

  pythonImportsCheck = [ "RsInstrument" ];

  doCheck = false; # package contains no tests

  meta = {
    description = "Provides a convenient way of communicating with R&S instruments";
    homepage = "https://rsinstrument.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
