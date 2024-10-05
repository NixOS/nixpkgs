{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "more-itertools";
  version = "10.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "more-itertools";
    repo = "more-itertools";
    rev = "v${version}";
    hash = "sha256-BDAcmVNw68v5So/uswg3lDyjIY7DLWSvvOKDbHyDn+o=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  # iterable = range(10 ** 10)  # Is efficiently reversible
  # OverflowError: Python int too large to convert to C long
  doCheck = !stdenv.hostPlatform.is32bit;

  meta = {
    homepage = "https://more-itertools.readthedocs.org";
    changelog = "https://more-itertools.readthedocs.io/en/stable/versions.html";
    description = "Expansion of the itertools module";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
