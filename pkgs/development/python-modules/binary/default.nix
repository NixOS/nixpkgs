{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "binary";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bsAQ5Y9zMevIvJY42+bGbWNd5g1YGLByO+9N6tDsKKY=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "binary"
    "binary.core"
  ];

  meta = with lib; {
    description = "Easily convert between binary and SI units (kibibyte, kilobyte, etc.)";
    homepage = "https://github.com/ofek/binary";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
