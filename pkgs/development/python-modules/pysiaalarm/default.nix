{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pycryptodome
, pytz
, setuptools-scm
, pytest-asyncio
, pytest-cases
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysiaalarm";
  version = "3.1.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ToNoPGg0dfLlkzzXf3jHR0JA2WSAWsRrS0HyU1qvzwk=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov pysiaalarm --cov-report term-missing" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pycryptodome
    pytz
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cases
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysiaalarm"
    "pysiaalarm.aio"
  ];

  meta = with lib; {
    description = "Python package for creating a client that talks with SIA-based alarm systems";
    homepage = "https://github.com/eavanvalkenburg/pysiaalarm";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
