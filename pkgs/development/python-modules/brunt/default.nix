{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  aiohttp,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "brunt";
  version = "1.2.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5wRifce5wKUMZ66Q8dMgsU+Z8rL8m/HvBGGxQdzxvOk=";
  };

  postPatch = ''
    sed -i '/--cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # tests require Brunt hardware
  doCheck = false;

  pythonImportsCheck = [ "brunt" ];

  meta = {
    description = "Unofficial Python SDK for Brunt";
    homepage = "https://github.com/eavanvalkenburg/brunt-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
