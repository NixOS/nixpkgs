{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  matplotlib,
  palettable,
  pandas,
  scipy,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mizani";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "mizani";
    rev = "refs/tags/v${version}";
    hash = "sha256-NQu1vzISMa0UnnSqU8ypp3pc3n6MUI1j5nYUPU14r9U=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    matplotlib
    palettable
    pandas
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=mizani --cov-report=xml" ""
  '';

  pythonImportsCheck = [ "mizani" ];

  meta = {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    changelog = "https://github.com/has2k1/mizani/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
