{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyparsing,
  decorator,
  six,
  future,
  setuptools,
  fetchpatch2,
}:

buildPythonPackage rec {
  pname = "pycontracts";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AndreaCensi";
    repo = "contracts";
    rev = "v${version}";
    hash = "sha256-91NG6tLncHp+kapvgwln2aqmLDHFqdzdhWl1QqjAfIk=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-python-collections.patch";
      url = "https://github.com/AndreaCensi/contracts/commit/d23ee2902e9e9aeffec86cbdb7a392d71be70861.patch";
      hash = "sha256-7fPkO5sm439ZgW1yTMML+pQOlC2zyfBU67H0XHI6QKI=";
      excludes = [ "src/contracts/__init__.py" ];
    })
  ];

  postPatch = ''
    substituteInPlace src/contracts/backported.py \
      --replace-fail "from inspect import ArgSpec" "" \
      --replace-fail "ArgSpec(" "FullArgSpec(" \
      --replace-fail "from inspect import getargspec" "from inspect import getfullargspec"
    substituteInPlace src/contracts/testing/test_decorator.py \
      --replace-fail "import getargspec" "import getfullargspec as getargspec"
    substituteInPlace src/contracts/testing/test_meta.py \
      --replace-fail "import nose" "" \
      --replace-fail "nose.SkipTest" "unittest.SkipTest"
  '';

  build-system = [ setuptools ];

  dependencies = [
    pyparsing
    decorator
    six
    future
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "src/contracts/testing/*.py" ];

  meta = {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = "https://pypi.python.org/pypi/PyContracts";
    license = lib.licenses.lgpl2;
    maintainers = [ ];
  };
}
