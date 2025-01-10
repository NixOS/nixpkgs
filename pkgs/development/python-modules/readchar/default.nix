{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
  pexpect,
}:

buildPythonPackage rec {
  pname = "readchar";
  version = "4.2.1";
  pyproject = true;

  # Don't use wheels on PyPI
  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-r+dKGv0a7AU+Ef94AGCCJLQolLqTTxaNmqRQYkxk15s=";
  };

  postPatch = ''
    # Tags on GitHub still have a postfix (-dev0)
    sed -i 's/\(version = "\)[^"]*\(".*\)/\1${version}\2/' pyproject.toml
    # run Linux tests on Darwin as well
    # see https://github.com/magmax/python-readchar/pull/99 for why this is not upstreamed
    substituteInPlace tests/linux/conftest.py \
      --replace 'sys.platform.startswith("linux")' 'sys.platform.startswith(("darwin", "linux"))'
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "readchar" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pexpect
  ];

  meta = with lib; {
    description = "Python library to read characters and key strokes";
    homepage = "https://github.com/magmax/python-readchar";
    changelog = "https://github.com/magmax/python-readchar/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
