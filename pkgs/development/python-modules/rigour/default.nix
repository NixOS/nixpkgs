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
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opensanctions";
    repo = "rigour";
    tag = "v${version}";
    hash = "sha256-F9fZN0Y6Kpv5Z3V3k3e0TgcSIVo9+zdL48AhrTZdTwU=";
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
