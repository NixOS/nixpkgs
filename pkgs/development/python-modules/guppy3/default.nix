{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tkinter,
}:

buildPythonPackage rec {
  pname = "guppy3";
  version = "3.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhuyifei1999";
    repo = "guppy3";
    tag = "v${version}";
    hash = "sha256-9pswuHLCxb/zLtyWfIRDmNPLFPamF4Ybb+7TbLf38fU=";
  };

  build-system = [ setuptools ];

  dependencies = [ tkinter ];

  # Tests are starting a Tkinter GUI
  doCheck = false;

  pythonImportsCheck = [ "guppy" ];

  meta = {
    changelog = "https://github.com/zhuyifei1999/guppy3/blob/${src.tag}/ChangeLog";
    description = "Python Programming Environment & Heap analysis toolset";
    homepage = "https://zhuyifei1999.github.io/guppy3/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
