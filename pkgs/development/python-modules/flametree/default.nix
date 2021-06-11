{ lib
, buildPythonPackage
, fetchFromGitHub
, fontconfig
, matplotlib
, pandas
, pytestCheckHook
, weasyprint
}:

buildPythonPackage rec {
  pname = "flametree";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "Edinburgh-Genome-Foundry";
    repo = "Flametree";
    rev = "v${version}";
    sha256 = "1ynrk1ivl1vjiga0ayl8k89vs5il7i0pf9jz2ycn771c47szwk4x";
  };

  checkInputs = [
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
