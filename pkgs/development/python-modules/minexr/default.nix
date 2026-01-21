{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  numpy,
  pillow,
}:

buildPythonPackage rec {
  pname = "minexr";
  version = "1.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cheind";
    repo = "py-minexr";
    tag = version;
    hash = "sha256-p42rlhaHq0A9+zk6c0evRDjNR1H/ruWJqPF5+nCTR8o=";
  };

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "minexr" ];
  nativeCheckInputs = [
    pytestCheckHook
    pillow
  ];

  meta = {
    description = "Minimal, standalone OpenEXR reader for single-part, uncompressed scan line files";
    homepage = "https://github.com/cheind/py-minexr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucasew ];
  };
}
