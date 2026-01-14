{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dedupe-levenshtein-search";
  version = "1.4.5";
  pyproject = true;

  # NOTE: This is a fork of mattandahalfew/Levenshtein_search created for MIT licensing.
  # TODO: Evaluate if upstream version could be used instead.
  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "Levenshtein_search";
    tag = "v${version}";
    hash = "sha256-YhsZA28H4OUkQEBtJ+9OXJld4Z/PJbOPqAQQ9qaXSjk=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "Levenshtein_search"
  ];

  meta = {
    description = "Search through documents for approximately matching strings using Levenshtein distance";
    homepage = "https://github.com/dedupeio/Levenshtein_search";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
