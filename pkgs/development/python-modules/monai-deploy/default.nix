{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pytest-lazy-fixture
, numpy
, networkx
, pydicom
, colorama
, typeguard
, versioneer
}:

buildPythonPackage rec {
  pname = "monai";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "monai-deploy-app-sdk";
    rev = "refs/tags/${version}";
    hash = "sha256-oaNZ0US0YR/PSwAZ5GfRpAW+HRYVhdCZI83fC00rgok=";
  };

  postPatch = ''
    # Asked in https://github.com/Project-MONAI/monai-deploy-app-sdk/issues/450
    # if this patch can be incorporated upstream.
    substituteInPlace pyproject.toml --replace 'versioneer-518' 'versioneer'
  '';

  nativeBuildInputs = [ versioneer ];

  propagatedBuildInputs = [
    numpy
    networkx
    colorama
    typeguard
  ];

  nativeCheckInputs = [ pytestCheckHook pytest-lazy-fixture ];
  disabledTests = [
    # requires Docker daemon:
    "test_packager"
  ];
  pythonImportsCheck = [
    "monai.deploy"
    "monai.deploy.core"
    # "monai.deploy.operators" should be imported as well but
    # requires some "optional" dependencies
    # like highdicom (which is not packaged yet) and pydicom
  ];

  meta = with lib; {
    description = "Framework and tools to design, develop and verify AI applications in healthcare imaging";
    homepage = "https://monai.io/deploy.html";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
