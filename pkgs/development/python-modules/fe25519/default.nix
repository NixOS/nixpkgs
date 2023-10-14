{ lib
, bitlist
, buildPythonPackage
, fetchPypi
, fountains
, parts
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "fe25519";
  version = "1.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-la+17tPHjceMTe7Wk8DGVaSptk8XJa+l7GTeqLIFDvs=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bitlist
    fountains
    parts
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--doctest-modules --ignore=docs --cov=fe25519 --cov-report term-missing" ""
  '';

  pythonImportsCheck = [
    "fe25519"
  ];

  meta = with lib; {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
