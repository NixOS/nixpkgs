{
  buildPythonPackage,
  lib,
  lxml,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  asn1crypto,
}:

buildPythonPackage rec {
  version = "0.3.31";
  format = "setuptools";
  pname = "pyaxmlparser";

  src = fetchFromGitHub {
    owner = "appknox";
    repo = "pyaxmlparser";
    rev = "v${version}";
    hash = "sha256-ZV2PyWQfK9xidzGUz7XPAReaVjlB8tMUKQiXoGcFCGs=";
  };

  propagatedBuildInputs = [
    asn1crypto
    click
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python3 Parser for Android XML file and get Application Name without using Androguard";
    mainProgram = "apkinfo";
    homepage = "https://github.com/appknox/pyaxmlparser";
    # Files from Androguard are licensed ASL 2.0
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mit
      asl20
    ];
    maintainers = [ ];
  };
}
