{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  libsodium,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysodium";
  version = "0.7.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stef";
    repo = "pysodium";
    tag = "v${version}";
    hash = "sha256-F2215AAI8UIvn6UbaJ/YxI4ZolCzlwY6nS5IafTs+i4=";
  };

  postPatch =
    let
      soext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      substituteInPlace ./pysodium/__init__.py --replace-fail \
        "ctypes.util.find_library('sodium') or ctypes.util.find_library('libsodium')" "'${libsodium}/lib/libsodium${soext}'"
    '';

  build-system = [ setuptools ];

  buildInputs = [ libsodium ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysodium" ];

  meta = {
    description = "Wrapper for libsodium providing high level crypto primitives";
    homepage = "https://github.com/stef/pysodium";
    changelog = "https://github.com/stef/pysodium/releases/tag/v${version}";
    maintainers = [ lib.maintainers.ethancedwards8 ];
    license = lib.licenses.bsd2;
  };
}
