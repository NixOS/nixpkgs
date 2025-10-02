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
  version = "27.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "e3-testsuite";
    tag = "v${version}";
    hash = "sha256-qG8SHwogBle3demgFJCqcfCh5ktLvOqh2XSwxPCANFk=";
  };

  build-system = [ setuptools ];

  dependencies = [ e3-core ];

  pythonImportsCheck = [ "e3" ];

  meta = with lib; {
    description = "Generic testsuite framework in Python";
    changelog = "https://github.com/AdaCore/e3-testsuite/releases/tag/${src.tag}";
    homepage = "https://github.com/AdaCore/e3-testsuite/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ heijligen ];
    platforms = platforms.linux;
  };
}
