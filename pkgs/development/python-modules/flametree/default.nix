{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,
  matplotlib,
  pandas,
  pytestCheckHook,
  weasyprint,
}:

buildPythonPackage rec {
  pname = "flametree";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Edinburgh-Genome-Foundry";
    repo = "Flametree";
    tag = "v${version}";
    hash = "sha256-5vtDfGmSX5niMXLnMqmafhq6D1gxhxVS3xbOAvQs3Po=";
  };

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
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
