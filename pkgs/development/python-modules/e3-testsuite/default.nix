{
  buildPythonPackage,
  e3-core,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "e3-testsuite";
  version = "26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "e3-testsuite";
    rev = "v${version}";
    hash = "sha256-V20tX0zi2DRHO42udUcW/CDMyBxh1uSTgac0zZGubsI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ e3-core ];

  pythonImportsCheck = [ "e3" ];

  meta = with lib; {
    changelog = "https://github.com/AdaCore/e3-testsuite/releases/tag/${src.rev}";
    homepage = "https://github.com/AdaCore/e3-testsuite/";
    description = "Generic testsuite framework in Python";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ heijligen ];
    platforms = platforms.linux;
  };
}
