{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libargon2,
  cffi,
  cmake,
  ninja,
  scikit-build-core,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "argon2-cffi-bindings";
  version = "26.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "argon2-cffi-bindings";
    tag = version;
    hash = "sha256-1938M2ALMcAIdTYTHCmJIAW1YyJPYhewZXOyFIJg/ZY=";
  };

  buildInputs = [ libargon2 ];

  build-system = [
    cffi
    cmake
    ninja
    setuptools-scm
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  dependencies = [ cffi ];

  env.ARGON2_CFFI_USE_SYSTEM = 1;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "_argon2_cffi_bindings" ];

  meta = {
    changelog = "https://github.com/hynek/argon2-cffi-bindings/releases/tag/${src.tag}";
    description = "Low-level CFFI bindings for Argon2";
    homepage = "https://github.com/hynek/argon2-cffi-bindings";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
