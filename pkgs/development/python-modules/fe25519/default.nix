{ lib
, bitlist
, buildPythonPackage
, fetchPypi
, fountains
, parts
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "fe25519";
  version = "1.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KWHYlHWNG/ATZP8WJ7e2M8ubQbQoT2ritWqSrl+92h0=";
  };

  nativeBuildInputs = [
    setuptools
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
