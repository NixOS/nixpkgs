{ lib
, buildPythonPackage
, cython_3
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dgAwcS1SczlvXpY92HMa77WsZdku/4v4/UEkwWMP6VA=";
  };

  build-system = [
    cython_3
    setuptools
  ];

  pythonImportsCheck = [
    "lupa"
  ];

  meta = with lib; {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/lupa-${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
