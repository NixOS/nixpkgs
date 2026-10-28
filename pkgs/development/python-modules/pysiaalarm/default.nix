{
  lib,
  buildPythonPackage,
  fetchPypi,
  dataclasses-json,
  pycryptodome,
  setuptools-scm,
  pytest-asyncio,
  pytest-cases,
  pytest-cov-stub,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysiaalarm";
  version = "3.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9icZnEpSaezVj9EH5s1u2mB2h9jP/oZcpkVE0WFM4W8=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    dataclasses-json
    pycryptodome
    pytz
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cases
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysiaalarm"
    "pysiaalarm.aio"
  ];

  meta = {
    description = "Python package for creating a client that talks with SIA-based alarm systems";
    homepage = "https://github.com/eavanvalkenburg/pysiaalarm";
    changelog = "https://github.com/eavanvalkenburg/pysiaalarm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
