{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  ipopt,
  numpy,
  pkg-config,
  pytestCheckHook,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyipopt";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mechmotum";
    repo = "cyipopt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qHOI4Bpjlz26FnqI2MOOCcKgD8FtocScLYGdXvc5zNU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ipopt ];

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cyipopt" ];

  # fix ModuleNotFoundError: No module named 'cyipopt.ipopt_wrapper'
  preInstallCheck = ''
    cp $out/${python.sitePackages}/cyipopt/ipopt_wrapper* cyipopt/
  '';

  meta = {
    description = "Cython interface for the interior point optimizer IPOPT";
    homepage = "https://github.com/mechmotum/cyipopt";
    changelog = "https://github.com/mechmotum/cyipopt/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
