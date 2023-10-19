{ lib
, buildPythonPackage
, fetchFromGitHub
, apispec
, boto3
, cachetools
, click
, localstack-client
, localstack-ext
, plux
, psutil
, python-dotenv
, pyyaml
, packaging
, requests
, rich
, semver
, tailer
}:

buildPythonPackage rec {
  pname = "localstack";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    rev = "refs/tags/v${version}";
    hash = "sha256-Sdyl/ccyhKRP5eb866ly1ZJrrFSQMLdX22R7UNRfDCA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "requests>=2.20.0,<2.26" "requests~=2.20" \
      --replace "cachetools~=5.0.0" "cachetools~=5.0" \
      --replace "boto3>=1.20,<1.25.0" "boto3~=1.20"
  '';

  propagatedBuildInputs = [
    apispec
    boto3
    cachetools
    click
    localstack-client
    localstack-ext
    plux
    psutil
    python-dotenv
    pyyaml
    packaging
    requests
    rich
    semver
    tailer
  ];

  pythonImportsCheck = [ "localstack" ];

  # Test suite requires boto, which has been removed from nixpkgs
  # Just do minimal test, buildPythonPackage maps checkPhase
  # to installCheckPhase, so we can test that entrypoint point works.
  checkPhase = ''
    $out/bin/localstack --version
  '';

  meta = with lib; {
    description = "A fully functional local Cloud stack";
    homepage = "https://github.com/localstack/localstack";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
