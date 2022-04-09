{ lib
, buildPythonPackage
, fetchFromGitHub
, attrs
, flake8
, pytestCheckHook
, hypothesis
, hypothesmith
}:

buildPythonPackage rec {
  pname = "flake8-bugbear";
  version = "22.3.23";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "sha256-s1EnPM2He+R+vafu14XI1Xuft8Rg6W3vPH2Atc6N7I0=";
  };

  propagatedBuildInputs = [
    attrs
    flake8
  ];

  checkInputs = [
    flake8
    pytestCheckHook
    hypothesis
    hypothesmith
  ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/flake8-bugbear";
    changelog = "https://github.com/PyCQA/flake8-bugbear/blob/${version}/README.rst#change-log";
    description = ''
      A plugin for flake8 finding likely bugs and design problems in your
      program.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
