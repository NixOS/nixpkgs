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
  version = "0.7.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stef";
    repo = "pysodium";
    tag = "v${version}";
    hash = "sha256-+RW6V3KriuaWP8aq7CChk6+qqHOctHaECaWZ8Vyudr8=";
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
