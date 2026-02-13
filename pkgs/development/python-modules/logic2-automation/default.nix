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

buildPythonPackage rec {
  pname = "logic2-automation";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "saleae";
    repo = "logic2-automation";
    rev = "v${version}";
    hash = "sha256-e0UvRwUs+rKFF3ky8bnHV22ZA9sU+AoghcMui2pIzQ0=";
  };

  # The proto files are in ./proto, the pyproject.toml is in ./python
  sourceRoot = "source/python";

  # See python/build.sh in the original repository
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

  # Tests require the unfree saleae-logic-2 package, plus gRPC server
  # This is very hard to package so it's skipped for now
  doCheck = false;

  pythonImportsCheck = [ "saleae.automation" ];

  meta = {
    description = "Automation interface for Saleae Logic 2 software";
    homepage = "https://github.com/saleae/logic2-automation";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ krishnans2006 ];
  };
}
