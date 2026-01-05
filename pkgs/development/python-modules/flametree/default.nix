{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,
  matplotlib,
  pandas,
  pytestCheckHook,
  setuptools,
  weasyprint,
}:

buildPythonPackage rec {
  pname = "flametree";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Edinburgh-Genome-Foundry";
    repo = "Flametree";
    tag = "v${version}";
    hash = "sha256-5vtDfGmSX5niMXLnMqmafhq6D1gxhxVS3xbOAvQs3Po=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    matplotlib
    pandas
    pytestCheckHook
    weasyprint
  ];

  preCheck = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  disabledTests = [
    # AssertionError, https://github.com/Edinburgh-Genome-Foundry/Flametree/issues/9
    "test_weasyprint"
  ];

  pythonImportsCheck = [ "flametree" ];

  meta = with lib; {
    description = "Python file and zip operations made easy";
    homepage = "https://github.com/Edinburgh-Genome-Foundry/Flametree";
    changelog = "https://github.com/Edinburgh-Genome-Foundry/Flametree/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
