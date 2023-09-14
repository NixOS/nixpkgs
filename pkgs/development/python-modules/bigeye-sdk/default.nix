{ lib
, python3
, fetchPypi
}:
python3.pkgs.buildPythonPackage rec {
  pname = "bigeye_sdk";
  version = "0.4.62";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
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
    pydantic-yaml
  ];

  meta = with lib; {
    homepage = "https://pypi.org/project/bigeye-sdk/";
    description = "Bigeye SDK offers developer tools and clients to interact with Bigeye programmatically.";
    mainProgram = "bigeye";
    maintainers = with maintainers; [ ];
  };
}
