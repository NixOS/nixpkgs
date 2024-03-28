{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, dataclasses-json
, pycryptodome
, setuptools-scm
, pytest-asyncio
, pytest-cases
, pytestCheckHook
, pytest_7
, pytz
}:

buildPythonPackage rec {
  pname = "pysiaalarm";
  version = "3.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q42bsBeAwU9lt7wtYGFJv23UBND+aMXZJlSWyTfZDQE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "==" ">="
    substituteInPlace pytest.ini \
      --replace "--cov pysiaalarm --cov-report term-missing" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dataclasses-json
    pycryptodome
    pytz
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cases
    (pytestCheckHook.override { pytest = pytest_7; })
  ];

  pythonImportsCheck = [
    "pysiaalarm"
    "pysiaalarm.aio"
  ];

  meta = with lib; {
    description = "Python package for creating a client that talks with SIA-based alarm systems";
    homepage = "https://github.com/eavanvalkenburg/pysiaalarm";
    changelog = "https://github.com/eavanvalkenburg/pysiaalarm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
