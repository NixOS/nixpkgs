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
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opensanctions";
    repo = "rigour";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-meeM/ylRJkZ1/Oh16oX572AkqxtU6gf8QtMIe8cCf8Y=";
=======
    hash = "sha256-0uqKcjGxI22jNt7lLP0LvhIyQO2yxV5tS6fW9QiQ814=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
