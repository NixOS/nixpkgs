{ lib
, python3
, fetchPypi
}:

let 
  old-pydantic-yaml = python3.pkgs.pydantic-yaml.overrideAttrs(_: {
    version = "0.8.1";
    src = fetchPypi {
      pname = "pydantic_yaml";
      version = "0.8.1";
      hash = "sha256-c5BaTmeCZtq+QXk93RaeqUUPkYE1gyLgCAL6Tugf+BY=";
    };
  });
in python3.pkgs.buildPythonPackage rec {
  pname = "bigeye-sdk";
  version = "0.4.62";
  format = "pyproject";

  src = fetchPypi {
    pname = "bigeye_sdk";
    inherit version;
    hash = "sha256-nP/TArEJ9Zt98hBSz4oZNSohjdK06XIs3JmKNYvrCyo=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    betterproto
    setuptools # needs pkg_resources at runtime
    rich
    requests
    pyyaml
    keyring
    rapidfuzz
    lz4
    pycryptodomex
    pydantic
    grpclib
    pygithub
    smart-open
    boto3
    secretstorage
    old-pydantic-yaml
  ];

  meta = with lib; {
    homepage = "https://pypi.org/project/bigeye-sdk/";
    description = "Offers developer tools and clients to interact with Bigeye programmatically.";
    mainProgram = "bigeye";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sree ];
  };
}
