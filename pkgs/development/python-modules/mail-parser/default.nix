{
  lib,
  buildPythonPackage,
  python,
  glibcLocales,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "mail-parser";
  version = "4.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SpamScope";
    repo = "mail-parser";
    tag = version;
    hash = "sha256-wwLUD/k26utugK/Yx9eXYEdSOvrk0Cy6RkXGDnzZ+fE=";
  };

  LC_ALL = "en_US.utf-8";

  nativeBuildInputs = [ glibcLocales ];

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "ipaddress" ];

  dependencies = [
    six
  ];

  pythonImportsCheck = [ "mailparser" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  # Taken from .travis.yml
  postCheck = ''
    ${python.interpreter} -m mailparser -v
    ${python.interpreter} -m mailparser -h
    ${python.interpreter} -m mailparser -f tests/mails/mail_malformed_3 -j
    cat tests/mails/mail_malformed_3 | ${python.interpreter} -m mailparser -k -j
  '';

  meta = {
    description = "Mail parser for python 2 and 3";
    mainProgram = "mailparser";
    homepage = "https://github.com/SpamScope/mail-parser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
