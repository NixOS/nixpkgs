{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  babel,
  banal,
  fingerprints,
  jellyfish,
  jinja2,
  normality,
  python-stdnum,
  pytz,
  pyyaml,
  rapidfuzz,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rigour";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opensanctions";
    repo = "rigour";
    tag = "v${version}";
    hash = "sha256-endggriOj+DBWfcYDQ034OvzxVCaHV9QUMAk0qtSYPg=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    babel
    banal
    fingerprints
    jellyfish
    jinja2
    normality
    python-stdnum
    pytz
    pyyaml
    rapidfuzz
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "rigour"
    "rigour.names"
    "rigour.ids"
    "rigour.langs"
    "rigour.mime"
    "rigour.addresses"
  ];

  meta = {
    description = "Data cleaning and validation functions for names, languages, identifiers, etc";
    homepage = "https://opensanctions.github.io/rigour";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
