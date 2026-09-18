{
  lib,
  buildPythonPackage,
  e3-core,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "e3-testsuite";
  version = "27.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "e3-testsuite";
    tag = "v${version}";
    hash = "sha256-qG8SHwogBle3demgFJCqcfCh5ktLvOqh2XSwxPCANFk=";
  };

  build-system = [ setuptools ];

  dependencies = [ e3-core ];

  pythonImportsCheck = [ "e3" ];

  meta = {
    description = "Generic testsuite framework in Python";
    changelog = "https://github.com/AdaCore/e3-testsuite/releases/tag/${src.tag}";
    homepage = "https://github.com/AdaCore/e3-testsuite/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ heijligen ];
    platforms = lib.platforms.linux;
  };
}
