{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  typing-extensions,
}:

let

  pname = "coloraide";
  version = "6.1";

in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = pname;
    tag = version;
    hash = "sha256-hsuFouesw4B9rr17NCQVB6LyYUdNRm9Cj2Cqj+MdLkc=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "coloraide"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library to aid in using colors";
    homepage = "https://github.com/facelessuser/coloraide";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
      lib.maintainers.djacu
    ];
  };
}
