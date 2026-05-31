{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  flit-scm,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "exceptiongroup";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "exceptiongroup";
    tag = version;
    hash = "sha256-3WInufN+Pp6vB/Gik6e8V1a34Dr/oiH3wDMB+2lHRMM=";
  };

  patches = [
    # CPython fixed https://github.com/python/cpython/issues/141732 in
    # https://github.com/python/cpython/pull/141736 (backported to Python 3.13+),
    # but exceptiongroup 1.3.1, including its test suite, still matches the old
    # repr behavior.
    # Upstream issue: https://github.com/agronholm/exceptiongroup/issues/154
    # Upstream PR: https://github.com/agronholm/exceptiongroup/pull/155
    (fetchpatch {
      name = "match-repr-fix.patch";
      url = "https://github.com/agronholm/exceptiongroup/commit/0c6cfbf677f6b50df17311cfdad01e9ff17310aa.patch";
      hash = "sha256-EeYu1/JKYRDwdq8+n38RrdogipNzX0ate1trDs1Z3c0=";
    })
  ];

  build-system = [ flit-scm ];

  dependencies = lib.optionals (pythonOlder "3.13") [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = pythonAtLeast "3.11"; # infinite recursion with pytest

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # RecursionError not raised
    "test_deep_split"
    "test_deep_subgroup"
  ];

  pythonImportsCheck = [ "exceptiongroup" ];

  meta = {
    description = "Backport of PEP 654 (exception groups)";
    homepage = "https://github.com/agronholm/exceptiongroup";
    changelog = "https://github.com/agronholm/exceptiongroup/blob/${version}/CHANGES.rst";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
