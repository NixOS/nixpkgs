{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "junitparser";
  version = "3.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "weiwei";
    repo = "junitparser";
    rev = version;
    hash = "sha256-efP9t5eto6bcjk33wpJmunLlPH7wUwAa6/OjjYG/fgM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    lxml
    glibcLocales
  ];

<<<<<<< HEAD
  meta = {
    description = "Manipulates JUnit/xUnit Result XML files";
    mainProgram = "junitparser";
    license = lib.licenses.asl20;
    homepage = "https://github.com/weiwei/junitparser";
    maintainers = with lib.maintainers; [ multun ];
=======
  meta = with lib; {
    description = "Manipulates JUnit/xUnit Result XML files";
    mainProgram = "junitparser";
    license = licenses.asl20;
    homepage = "https://github.com/weiwei/junitparser";
    maintainers = with maintainers; [ multun ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
