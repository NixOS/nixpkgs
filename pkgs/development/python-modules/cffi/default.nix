{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  libffi,
  nix-update-script,
  pkg-config,
  pycparser,
  pytestCheckHook,
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "cffi";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-cffi";
    repo = "cffi";
    tag = "v${version}";
    hash = "sha256-7Mzz3KmmmE2xQru1GA4aY0DZqn6vxykWiExQvnA1bjM=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools ];

  buildInputs = [ libffi ];

  dependencies = [ pycparser ];

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unused-command-line-argument -Wno-unreachable-code -Wno-c++11-narrowing";

  doCheck = !(stdenv.hostPlatform.isMusl || stdenv.hostPlatform.useLLVM or false);

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/python-cffi/cffi/releases/tag/v${version}";
    description = "Foreign Function Interface for Python calling C code";
    downloadPage = "https://github.com/python-cffi/cffi";
    homepage = "https://cffi.readthedocs.org/";
    license = lib.licenses.mit0;
    teams = [ lib.teams.python ];
  };
}
