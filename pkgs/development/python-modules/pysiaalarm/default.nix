{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  dataclasses-json,
  pycryptodome,
  setuptools-scm,
  pytest-asyncio_0,
  pytest-cases,
  pytest-cov-stub,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "pysiaalarm";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q42bsBeAwU9lt7wtYGFJv23UBND+aMXZJlSWyTfZDQE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "==" ">="
  '';

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [
    dataclasses-json
    pycryptodome
    pytz
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytest-cases
    pytest-cov-stub
    pytestCheckHook
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
