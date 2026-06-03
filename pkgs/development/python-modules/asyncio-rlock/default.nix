{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "asyncio-rlock";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "asyncio_rlock";
    inherit (finalAttrs) version;
    sha256 = "7e29824331619873e10d5d99dcc46d7b8f196c4a11b203f4eeccc0c091039d43";
  };

  build-system = [ setuptools ];

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "asyncio_rlock" ];

  meta = {
    description = "Rlock like in threading module but for asyncio";
    homepage = "https://gitlab.com/heckad/asyncio_rlock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
