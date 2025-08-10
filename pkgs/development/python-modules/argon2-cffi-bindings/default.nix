{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libargon2,
  cffi,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "argon2-cffi-bindings";
  version = "25.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "argon2-cffi-bindings";
    tag = version;
    hash = "sha256-UDPxwqEpsmByAPM7lz3cxZz8jWwCEdghPlKXt8zQrfc=";
  };

  buildInputs = [ libargon2 ];

  build-system = [
    setuptools-scm
    cffi
  ];

  dependencies = [ cffi ];

  env.ARGON2_CFFI_USE_SYSTEM = 1;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "_argon2_cffi_bindings" ];

  meta = with lib; {
    changelog = "https://github.com/hynek/argon2-cffi-bindings/releases/tag/${src.tag}";
    description = "Low-level CFFI bindings for Argon2";
    homepage = "https://github.com/hynek/argon2-cffi-bindings";
    license = licenses.mit;
    maintainers = [ ];
  };
}
