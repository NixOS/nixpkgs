{
  lib,
  buildPythonPackage,
  e3-core,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "e3-testsuite";
  version = "26.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "e3-testsuite";
    rev = "refs/tags/v${version}";
    hash = "sha256-V20tX0zi2DRHO42udUcW/CDMyBxh1uSTgac0zZGubsI=";
  };

  build-system = [ setuptools ];

  dependencies = [ e3-core ];

  pythonImportsCheck = [ "e3" ];

  meta = with lib; {
    description = "Generic testsuite framework in Python";
    changelog = "https://github.com/AdaCore/e3-testsuite/releases/tag/${src.rev}";
    homepage = "https://github.com/AdaCore/e3-testsuite/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ heijligen ];
    platforms = platforms.linux;
  };
}
