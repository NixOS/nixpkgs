{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  fetchpatch,
  # Python deps
  mando,
  colorama,
  pytest-mock,
  tomli,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "radon";
  version = "6.0.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "rubik";
    repo = "radon";
    rev = "v${version}";
    hash = "sha256-yY+j9kuX0ou/uDoVI/Qfqsmq0vNHv735k+vRl22LwwY=";
  };

  patches = [
    # NOTE: Remove after next release
    (fetchpatch {
      url = "https://github.com/rubik/radon/commit/ce5d2daa0a9e0e843059d6f57a8124c64a87a6dc.patch";
      hash = "sha256-WwcfR2ZEWeRiMKdMZAwtZRBcWOqoqpaVTmVo0k+Tn74=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  propagatedBuildInputs = [
    mando
    colorama
  ];

  pythonRelaxDeps = [
    "mando"
  ];

  optional-dependencies = {
    toml = [ tomli ];
  };

  pythonImportsCheck = [ "radon" ];

  meta = with lib; {
    description = "Various code metrics for Python code";
    homepage = "https://radon.readthedocs.org";
    changelog = "https://github.com/rubik/radon/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "radon";
  };
}
