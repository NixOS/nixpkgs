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
, tox
, go
, pulumictl
, bash
, pylint
, pytest
, pytest-timeout
, coverage
, black
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
    bash
    go
    tox
    pytest
    pytest-timeout
    coverage
    pytest-asyncio
    wheel
    black
  ];

  pythonImportsCheck = ["pulumi"];

  postPatch = ''
    cp README.md sdk/python/lib
    patchShebangs .
    cd sdk/python/lib

    substituteInPlace setup.py \
      --replace "{VERSION}" "${version}"
  '';

  # disabled because tests try to fetch go packages from the net
  doCheck = false;

  meta = with lib; {
    description = "Modern Infrastructure as Code. Any cloud, any language";
    homepage = "https://github.com/pulumi/pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
