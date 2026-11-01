{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ptyprocess";
  version = "0.7.0-unstable-2026-08-26"; # last release in 2020, various unreleased fixes merged since
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pexpect";
    repo = "ptyprocess";
    rev = "12d3221806c0a7cf114b894101814b1f9e338ed4";
    hash = "sha256-WGxHmh60pHi6tjmAA6c2MzRLfy18JRTK5S8UmSsAbWs=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ptyprocess" ];

  meta = {
    description = "Run a subprocess in a pseudo terminal";
    homepage = "https://github.com/pexpect/ptyprocess";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ getchoo ];
  };
})
