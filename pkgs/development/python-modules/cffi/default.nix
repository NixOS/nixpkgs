{
  lib,
  stdenv,
  buildPythonPackage,
  isPyPy,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  libffi,
  pkg-config,
  pycparser,
}:

let
  version = "1.17.1";
in
if isPyPy then
  buildPythonPackage {
    pname = "cffi";
    inherit version;
    pyproject = false;

    # cffi is bundled with PyPy.
    dontUnpack = true;

    # Some dependent packages expect to have pycparser available when using cffi.
    dependencies = [ pycparser ];

    meta = {
      description = "Foreign Function Interface for Python calling C code (bundled with PyPy, placeholder package)";
      homepage = "https://cffi.readthedocs.org/";
      license = lib.licenses.mit;
      maintainers = lib.teams.python.members;
    };
  }
else
  buildPythonPackage rec {
    pname = "cffi";
    inherit version;
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-HDnGAWwyvEjdVFYZUOvWg24WcPKuRhKPZ89J54nFKCQ=";
    };

    patches = [
      #
      # Trusts the libffi library inside of nixpkgs on Apple devices.
      #
      # Based on some analysis I did:
      #
      #   https://groups.google.com/g/python-cffi/c/xU0Usa8dvhk
      #
      # I believe that libffi already contains the code from Apple's fork that is
      # deemed safe to trust in cffi.
      #
      ./darwin-use-libffi-closures.diff
    ];

    nativeBuildInputs = [ pkg-config ];

    build-system = [ setuptools ];

    buildInputs = [ libffi ];

    dependencies = [ pycparser ];

    # The tests use -Werror but with python3.6 clang detects some unreachable code.
    env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unused-command-line-argument -Wno-unreachable-code -Wno-c++11-narrowing";

    doCheck = !(stdenv.hostPlatform.isMusl || stdenv.hostPlatform.useLLVM or false);

    nativeCheckInputs = [ pytestCheckHook ];

    disabledTests = lib.optionals stdenv.hostPlatform.isFreeBSD [
      # https://github.com/python-cffi/cffi/pull/144
      "test_dlopen_handle"
    ];

    meta = with lib; {
      changelog = "https://github.com/python-cffi/cffi/releases/tag/v${version}";
      description = "Foreign Function Interface for Python calling C code";
      downloadPage = "https://github.com/python-cffi/cffi";
      homepage = "https://cffi.readthedocs.org/";
      license = licenses.mit;
      maintainers = teams.python.members;
    };
  }
