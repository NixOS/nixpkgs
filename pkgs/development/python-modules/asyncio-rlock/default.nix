{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asyncio-rlock";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "asyncio_rlock";
    inherit version;
    hash = "sha256-fimCQzFhmHPhDV2Z3MRte48ZbEoRsgP07szAwJEDnUM=";
  };

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "asyncio_rlock" ];

  meta = with lib; {
    description = "Rlock like in threading module but for asyncio";
    homepage = "https://gitlab.com/heckad/asyncio_rlock";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
