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
  version = "0.1.12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Edinburgh-Genome-Foundry";
    repo = "Flametree";
    rev = "refs/tags/v${version}";
    hash = "sha256-oyiuhsYouGDKRssKc0aYIoG32H7GS6Bn4RtI7/9N158=";
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
