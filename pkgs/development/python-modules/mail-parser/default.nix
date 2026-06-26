{
  lib,
  buildPythonPackage,
  python,
  extract-msg,
  fetchFromGitHub,
  hatchling,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mail-parser";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SpamScope";
    repo = "mail-parser";
    tag = finalAttrs.version;
    hash = "sha256-fuL2cWQSkYQKhG/UVNOp4ch4MrZINizvsPCQUzb3Z9c=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    outlook = [ extract-msg ];
  };

  pythonImportsCheck = [ "mailparser" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # Taken from .github/workflows/main.yml
  postCheck = ''
    ${python.interpreter} -m mailparser -v
    ${python.interpreter} -m mailparser -h
    ${python.interpreter} -m mailparser -f tests/mails/mail_malformed_3 -j
    ${python.interpreter} -m mailparser -f tests/mails/mail_outlook_1 -j
    cat tests/mails/mail_malformed_3 | ${python.interpreter} -m mailparser -k -j
  '';

  meta = {
    changelog = "https://github.com/SpamScope/mail-parser/releases/tag/${finalAttrs.src.tag}";
    description = "Mail parser for python 2 and 3";
    mainProgram = "mail-parser";
    homepage = "https://github.com/SpamScope/mail-parser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
})
