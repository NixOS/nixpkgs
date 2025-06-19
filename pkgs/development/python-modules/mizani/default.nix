{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  matplotlib,
  palettable,
  pandas,
  scipy,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mizani";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "mizani";
    tag = "v${version}";
    hash = "sha256-80LC1VRAr95Y25TkD6UIk5/2MPTunLu1wfVY6ps4Wt4=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    matplotlib
    palettable
    pandas
    scipy
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mizani" ];

  meta = {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    changelog = "https://github.com/has2k1/mizani/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
