{
  lib,
  ahocorasick-rs,
  babel,
  banal,
  buildPythonPackage,
  fetchFromGitHub,
  fingerprints,
  hatchling,
  jellyfish,
  jinja2,
  normality,
  orjson,
  pytestCheckHook,
  python-stdnum,
  pytz,
  pyyaml,
  rapidfuzz,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "rigour";
  version = "1.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opensanctions";
    repo = "rigour";
    tag = "v${version}";
    hash = "sha256-XlKP5XHJGnDwaHS43enkGVPoSXDz7+oEyDSG3xghBXM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    ahocorasick-rs
    babel
    banal
    fingerprints
    jellyfish
    jinja2
    normality
    orjson
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
