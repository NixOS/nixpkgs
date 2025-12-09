{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "justbases";
  version = "0.15.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mulkieran";
    repo = "justbases";
    tag = "v${version}";
    hash = "sha256-XraUh3beI2JqKPRHYN5W3Tn3gg0GJCwhnhHIOFdzh6U=";
  };

  nativeCheckInputs = [
    unittestCheckHook
    hypothesis
  ];

  meta = with lib; {
    description = "Conversion of ints and rationals to any base";
    homepage = "https://github.com/mulkieran/justbases";
    changelog = "https://github.com/mulkieran/justbases/blob/v${version}/CHANGES.txt";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
