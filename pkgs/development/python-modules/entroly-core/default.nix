{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
}:
let
  version_v = "1.0.87";
in
buildPythonPackage (finalAttrs: {
  pname = "entroly-core";
  version = version_v;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "juyterman1000";
    repo = "entroly";
    rev = "entroly-v${version_v}";
    hash = "sha256-xWCfEV91zUOQdHTh+v4e+/JkTD8nkyln0Mv/7NUoWko=";
  };

  build-system = (
    with rustPlatform;
    [
      cargoSetupHook
      maturinBuildHook
    ]
  );

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/entroly-core";
    pname = "${finalAttrs.pname}-vendor";
    inherit version_v;
    hash = "sha256-Ta1Gb3RLPikiuH+npeT22hDUkL6taQb3NKXsaC+krYM=";
  };

  postUnpack = ''
    export sourceRoot="source/entroly-core"
    chmod -R u+w "$sourceRoot"
  '';

  pythonImportsCheck = [ "entroly_core" ];

  meta = {
    description = "Information-theoretic context optimization for AI coding agents";
    homepage = "https://github.com/juyterman1000/entroly/entroly-core";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.guelakais ];
  };
})
