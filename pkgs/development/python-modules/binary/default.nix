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
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VcatT2tIji67wKheXlCp9RoChOmYcMkKr0vnfvM7d9E=";
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
