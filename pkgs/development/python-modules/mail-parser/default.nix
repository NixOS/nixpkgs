{
  lib,
  buildPythonPackage,
  python,
  extract-msg,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mail-parser";
  version = "4.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SpamScope";
    repo = "mail-parser";
    tag = finalAttrs.version;
    hash = "sha256-eiLnNTkBanoJkBthOLsblL0VEWNUKtGV1c2obMuUXJA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling>=1.27,<1.32" "hatchling"
  '';

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

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
    description = "Mail parser";
    homepage = "https://github.com/SpamScope/mail-parser";
    changelog = "https://github.com/SpamScope/mail-parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ psyanticy ];
    mainProgram = "mail-parser";
  };
})
