{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynfsclient";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    pname = "pyNfsClient";
    inherit version;
    hash = "sha256-xgZL08NlMCpSkALQwklh7Xq16bK2Sm2hAynbrIWsgaU=";
  };

  postPatch = ''
    # HISTORY.md is missing
    substituteInPlace setup.py \
      --replace-fail "HISTORY.md" "README.rst"
  '';

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyNfsClient" ];

  meta = {
    description = "Pure python NFS client";
    homepage = "https://pypi.org/project/pyNfsClient/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
