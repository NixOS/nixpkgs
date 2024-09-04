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
    rev = "refs/tags/release-${version}";
    hash = "sha256-n5E75kRqe0dDbyFicoyLBAVi/SuoUU7qJka3viipQk8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "liblzf python bindings";
    homepage = "https://github.com/teepark/python-lzf";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
