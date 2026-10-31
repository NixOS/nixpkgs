{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grpcio-tools,
  setuptools,
  wheel,
  getmac,
  protobuf,
}:

buildPythonPackage (finalAttrs: {
  pname = "bitvis-protobuf";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitvis-io";
    repo = "bitvis-protobuf";
    tag = finalAttrs.version;
    hash = "sha256-WLbWm37VsyTJ2wba8K5dGnILsmp31Kd7OFgK0ScwhRA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "grpcio-tools>=1.64.0,<=1.80.0" "grpcio-tools>=1.64.0"
  '';

  build-system = [
    grpcio-tools
    setuptools
    wheel
  ];

  dependencies = [
    getmac
    protobuf
  ];

  doCheck = false; # Upstream has no tests.

  pythonImportsCheck = [
    "bitvis_protobuf"
    "bitvis_protobuf.cli"
  ];

  meta = {
    description = "Protobuf definitions for Bitvis Power Hub";
    homepage = "https://github.com/bitvis-io/bitvis-protobuf";
    changelog = "https://github.com/bitvis-io/bitvis-protobuf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "bitvis-listen";
  };
})
