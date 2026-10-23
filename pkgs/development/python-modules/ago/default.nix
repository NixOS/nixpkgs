{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ago";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ewnXDTtpi9fdbtlSWDQwlDuRVpBo3rKhgEgOQRvJDEc=";
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
