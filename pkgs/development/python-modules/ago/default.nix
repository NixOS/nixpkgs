{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ago";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FWBBWXEcR+CPISUfKL+0ODlCCHU1Zg2+ZAsvYZP5K+Q=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ago" ];

  meta = {
    description = "Human Readable Time Deltas";
    homepage = "https://git.unturf.com/python/ago";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
