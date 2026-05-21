{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "entroly-core";
  version = "0.19.13";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "juyterman1000";
    repo = "entroly";
    rev = "entroly-v${version}";
    hash = "sha256-Nh0BSTLDwVk373kn9JDW/tCpWXPU6n7GH93zCcshCI0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${src}/entroly-core";
    pname = "${pname}-vendor";
    inherit version;
    hash = "sha256-DCIuTYd55rdHSY3BUhGxagDJDJPncnu6W0sQmeUINJY=";
  };

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

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
}
