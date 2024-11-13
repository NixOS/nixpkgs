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
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SpamScope";
    repo = "mail-parser";
    rev = "refs/tags/${version}";
    hash = "sha256-WpV1WJFwzAquPXimew86YpEp++dnkIiBe5E4lMBDl7w=";
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

  meta = with lib; {
    description = "Mail parser for python 2 and 3";
    mainProgram = "mailparser";
    homepage = "https://github.com/SpamScope/mail-parser";
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
