{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-scm,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  isPy313,
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

  # CPython fixed https://github.com/python/cpython/issues/141732 in
  # https://github.com/python/cpython/pull/141736, but exceptiongroup 1.3.1,
  # including its test suite, still matches the old repr behavior.
  # The CPython fix has only been backported to 3.13 so far, where it was
  # first included in version 3.13.12, so we only need to patch for 3.13
  # and 3.15+.
  # Upstream issue: https://github.com/agronholm/exceptiongroup/issues/154
  patches = lib.optional (isPy313 || pythonAtLeast "3.15") ./match-repr-fix.patch;

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
