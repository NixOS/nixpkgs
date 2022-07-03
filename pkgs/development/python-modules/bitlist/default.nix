{ lib
, buildPythonPackage
, fetchPypi
, nose
, parts
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-43Oh1ERGsW12HOqpbIa7rzLKrP9tIjckZhHwZSmBypE=";
  };

  propagatedBuildInputs = [
    parts
  ];

  checkInputs = [
    pytestCheckHook
    nose
  ];

  pythonImportsCheck = [
    "bitlist"
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=bitlist --cov-report term-missing" ""
  '';

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
