{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
  rich,
}:

buildPythonPackage rec {
  pname = "rich-argparse";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hamdanal";
    repo = "rich-argparse";
    tag = "v${version}";
    hash = "sha256-gLXFiWgGMDOUbTyoSgTr0XfotVfDxwMqPdsfE4KHzXM=";
  };

  build-system = [ hatchling ];

  dependencies = [ rich ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rich_argparse" ];

<<<<<<< HEAD
  meta = {
    description = "Format argparse help output using rich";
    homepage = "https://github.com/hamdanal/rich-argparse";
    changelog = "https://github.com/hamdanal/rich-argparse/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ graham33 ];
=======
  meta = with lib; {
    description = "Format argparse help output using rich";
    homepage = "https://github.com/hamdanal/rich-argparse";
    changelog = "https://github.com/hamdanal/rich-argparse/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
