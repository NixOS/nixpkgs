{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-slugify,
  jinja2,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "python-nvd3";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "areski";
    repo = "python-nvd3";
    rev = "dc8e772597ed72f413b229856fc9a3318e57fcfc";
    sha256 = "1vjnicszcc9j0rgb58104fk9sry5xad1xli64jana9bkx42c6x1v";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-slugify
    jinja2
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  meta = {
    homepage = "https://github.com/areski/python-nvd3";
    description = "Python Wrapper for NVD3 - It's time for beautiful charts";
    mainProgram = "nvd3";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ivan-tkatchev ];
  };
}
