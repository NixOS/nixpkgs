{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  hatchling,

  # dependencies
  grpcio,
  grpcio-tools,
  protobuf,
}:

buildPythonPackage (finalAttrs: {
  pname = "logic2-automation";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "saleae";
    repo = "logic2-automation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e0UvRwUs+rKFF3ky8bnHV22ZA9sU+AoghcMui2pIzQ0=";
  };

  sourceRoot = "source/python";

  preBuild = "./build.sh";

  pyproject = true;

  build-system = [
    hatchling
  ];

  dependencies = [
    grpcio
    grpcio-tools
    protobuf
  ];

  # Tests require the unfree saleae-logic-2 package, plus gRPC server which is not packaged, yet.
  doCheck = false;

  pythonImportsCheck = [ "saleae.automation" ];

  meta = {
    description = "Automation interface for Saleae Logic 2 software";
    homepage = "https://github.com/saleae/logic2-automation";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ krishnans2006 ];
  };
})
