{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools
, pytest
, locket
, numpy
, pandas
, pyzmq
, toolz
}:

buildPythonPackage rec {
  pname = "partd";
  version = "1.4.1";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VsJd1J5v6lcn5zEgPEZsbgkvMI2PACThmdAvaqIWf2c=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ pytest ];

  propagatedBuildInputs = [ locket numpy pandas pyzmq toolz ];

  checkPhase = ''
    rm partd/tests/test_zmq.py # requires network & fails
    py.test -k "not test_serialize"
  '';

  meta = {
    description = "Appendable key-value storage";
    license = with lib.licenses; [ bsd3 ];
    homepage = "https://github.com/dask/partd/";
  };
}
