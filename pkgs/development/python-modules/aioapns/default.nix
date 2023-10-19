{ buildPythonPackage
, fetchPypi
, setuptools
, h2
, lib
, pyjwt
, pyopenssl
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioapns";
  version = "3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MiFjd9HYaTugjP66O24Tgk92bC91GQHggvy1sdQIu+0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    h2
    pyopenssl
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioapns" ];

  meta = with lib; {
    description = "An efficient APNs Client Library for Python/asyncio";
    homepage = "https://github.com/Fatal1ty/aioapns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
