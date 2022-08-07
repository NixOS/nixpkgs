{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, protobuf
, dill
, grpcio
, pulumi-bin
, isPy27
, semver
, pyyaml
, six


# for tests
, go
, pulumictl
, pylint
, pytest
, pytest-timeout
, wheel
, pytest-asyncio

, mypy
}:
let
  data = import ./data.nix {};
in
buildPythonPackage rec {
  pname = "pulumi";
  version = pulumi-bin.version;
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi";
    rev = "v${pulumi-bin.version}";
    sha256 = "sha256-vqEZEHTpJV65a3leWwYhyi3dzAsN67BXOvk5hnTPeuI=";
  };

  propagatedBuildInputs = [
    semver
    protobuf
    dill
    grpcio
    pyyaml
    six
  ];

  checkInputs = [
    pulumi-bin
    pulumictl
    mypy
    go
    pytest
    pytest-timeout
    pytest-asyncio
    wheel
  ];

  sourceRoot="source/sdk/python/lib";
  # we apply the modifications done in the pulumi/sdk/python/Makefile
  # but without the venv code
  postPatch = ''
    cp ../../README.md .
    sed -i "s/\''${VERSION}/${version}/g" setup.py
  '';

  # disabled because tests try to fetch go packages from the net
  doCheck = false;

  pythonImportsCheck = ["pulumi"];

  meta = with lib; {
    description = "Modern Infrastructure as Code. Any cloud, any language";
    homepage = "https://github.com/pulumi/pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
