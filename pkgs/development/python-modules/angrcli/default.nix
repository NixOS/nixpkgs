{
  lib,
  angr,
  buildPythonPackage,
  cmd2,
  coreutils,
  fetchFromGitHub,
  pygments,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  pname = "angrcli";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "fmagin";
    repo = "angr-cli";
    tag = "v${version}";
    hash = "sha256-egu7jlEk8/i36qQMHztGr959sBt9d5crW8mj6+sKaHI=";
  };

  postPatch = ''
    substituteInPlace tests/test_derefs.py \
      --replace-fail "/bin/ls" "${coreutils}/bin/ls"
  '';

  build-system = [ setuptools ];

  dependencies = [
    angr
    cmd2
    pygments
  ];

  nativeCheckInputs = [
    coreutils
    pytestCheckHook
  ];

  disabledTests = lib.optionals (!stdenv.hostPlatform.isx86) [
    # expects the x86 register "rax" to exist
    "test_cc"
    "test_loop"
    "test_max_depth"
  ];

  pythonImportsCheck = [ "angrcli" ];

  meta = with lib; {
    description = "Python modules to allow easier interactive use of angr";
    homepage = "https://github.com/fmagin/angr-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
