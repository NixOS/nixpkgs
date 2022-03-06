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

buildPythonPackage rec {
  pname = "pulumi";
  version = pulumi.version;
  disabled = isPy27;

  src = pulumi.src;

  patches = [
    # remove in next release
    (fetchpatch {
      url = "https://github.com/pulumi/pulumi/commit/d4b9d61d70972d22a344419fafc30aace58607f5.patch";
      sha256 = "HEF7VWunFO+NCG18fZA7lbE2l8pc6Z3jcD+rSZ1Jsqg=";
    }) ];

  # src = fetchFromGitHub {
  #   owner = "pulumi";
  #   repo = "pulumi";
  #   rev = "073e94a0b8b4ef0b1b856c63670a8dd88f6b6d02";
  #   sha256 = "sha256-oyjQW/Z1NvsHpUwikX+bl1npfF4LESOua/o1qjqAgUs=";
  # };

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
    # pylint
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
    substituteInPlace ../Makefile \
      --replace '$(shell cd ../../ && pulumictl get version)' '${pulumi-bin.version}' \
      --replace '$(shell cd ../../ && pulumictl get version --language python)' '${version}'

    substituteInPlace ../requirements.txt \
      --replace 'pylint==2.10.2' 'pylint>=2.10.2'

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
