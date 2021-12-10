{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "gemfileparser";
  version = "0.8.0";

  src = fetchFromGitHub {
     owner = "gemfileparser";
     repo = "gemfileparser";
     rev = "v0.8.0";
     sha256 = "10qq6p1i60g72cxxawhpndbf4w9amgcmc50jfprb7p96bgcc0cbg";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gemfileparser"
  ];

  meta = with lib; {
    description = "A library to parse Ruby Gemfile, .gemspec and Cocoapod .podspec file using Python";
    homepage = "https://github.com/gemfileparser/gemfileparser";
    license = with licenses; [ gpl3Plus /* or */ mit ];
    maintainers = teams.determinatesystems.members;
  };
}
