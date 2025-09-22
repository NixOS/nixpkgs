{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  importlib-metadata,
  numpy,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfma";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "pyfma";
    rev = version;
    hash = "sha256-1qNa+FcIAP1IMzdNKrEbTVPo6gTOSCvhTRIHm6REJoo=";
  };

  patches = [
    # Replace deprecated np.find_common_type calls with np.promote_types, https://github.com/nschloe/pyfma/pull/17
    (fetchpatch {
      url = "https://github.com/nschloe/pyfma/commit/e12d69d97a97657ab4fec3e8f2b2859f4360bc03.patch";
      hash = "sha256-BsQe4hpo+Cripa0FRGFnRBs1oQ1GZA1+ZYzycy5M4Ek=";
    })
  ];

  build-system = [ setuptools ];

  buildInputs = [ pybind11 ];

  dependencies = [ numpy ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfma" ];

  meta = with lib; {
    description = "Fused multiply-add for Python";
    homepage = "https://github.com/nschloe/pyfma";
    changelog = "https://github.com/nschloe/pyfma/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
