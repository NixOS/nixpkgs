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
  version = "4.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "weiwei";
    repo = "junitparser";
    tag = version;
    hash = "sha256-+81n5xW9SEE+NZbYKxXu6xupoq4/haUZokVardh43iM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    lxml
    glibcLocales
  ];

  meta = {
    description = "Manipulates JUnit/xUnit Result XML files";
    mainProgram = "junitparser";
    license = lib.licenses.asl20;
    homepage = "https://github.com/weiwei/junitparser";
    maintainers = with lib.maintainers; [ multun ];
  };
}
