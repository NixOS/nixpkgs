{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gdb,
  pytest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygdbmi";
  version = "0.11.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs01";
    repo = "pygdbmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JqEDN8Pg/JttyYQbwkxKkLYuxVnvV45VlClD23eaYyc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    gdb
    pytest
  ];

  # tests require gcc for some reason
  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    # tries to execute flake8,
    # which is likely to break on flake8 updates
    echo "def main(): return 0" > tests/static_tests.py
  '';

  meta = {
    description = "Parse gdb machine interface output with Python";
    homepage = "https://github.com/cs01/pygdbmi";
    changelog = "https://github.com/cs01/pygdbmi/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mic92 ];
  };
})
