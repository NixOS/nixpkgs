{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  version = "0.2.6";
  pname = "python-lzf";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "teepark";
    repo = "python-lzf";
    tag = "release-${version}";
    hash = "sha256-n5E75kRqe0dDbyFicoyLBAVi/SuoUU7qJka3viipQk8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Liblzf python bindings";
    homepage = "https://github.com/teepark/python-lzf";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
