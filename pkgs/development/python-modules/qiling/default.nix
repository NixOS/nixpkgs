{
  lib,
  buildPythonPackage,
  unittestCheckHook,
  poetry-core,
  capstone,
  fetchFromGitHub,
  gevent,
  keystone-engine,
  multiprocess,
  pefile,
  pyelftools,
  python-fx,
  python-registry,
  pyyaml,
  questionary,
  termcolor,
  unicorn,
}:
buildPythonPackage (finalAttrs: {
  pname = "qiling";
  version = "1.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qilingframework";
    repo = "qiling";
    tag = finalAttrs.version;
    hash = "sha256-B3p3Ve/mZvKZLbVlEjItS+O4tSYwJV7wSsj0gV/CZq8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    capstone
    gevent
    keystone-engine
    multiprocess
    pefile
    pyelftools
    python-fx
    python-registry
    pyyaml
    termcolor
    questionary
    unicorn
  ];

  pythonRelaxDeps = [
    "capstone"
    "unicorn"
  ];

  pythonImportsCheck = [ "qiling" ];
  # to be enabled in the future, when we figure out how to exclude tests from unittestCheckHook
  # nativeCheckInputs = [ unittestCheckHook ];
  # doCheck = false;

  meta = {
    description = "Qiling Advanced Binary Emulation Framework";
    homepage = "https://qiling.io/";
    changelog = "https://github.com/qilingframework/qiling/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ BonusPlay ];
  };
})
