{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, rustPlatform
, libiconv
}:

buildPythonPackage rec {
  pname = "dbt-extractor";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "dbt_extractor";
    inherit version;
    hash = "sha256-dbHGZWmewPH/zhuj13b3386AIVbyLnCnucjwtNfoD0I=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-jinja2-0.1.0" = "sha256-lzA2iq4AK0iNwkLvbIt7Jm5WGFbMPFDi6i4AFDm0FOU=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  # no python tests exist
  doCheck = false;

  pythonImportsCheck = [
    "dbt_extractor"
  ];

  meta = with lib; {
    description = "A tool that processes the most common jinja value templates in dbt model files";
    homepage = "https://github.com/dbt-labs/dbt-extractor";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch tjni ];
  };
}
