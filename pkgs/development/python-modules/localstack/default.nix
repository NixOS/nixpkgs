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
, requests
, rich
, semver
, tailer
}:

buildPythonPackage rec {
  pname = "localstack";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    rev = "v${version}";
    sha256 = "sha256-JDF3wM5AVhfkAFlxmy1f3aMxs4J5LWd0JOY8MzRAzT4=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "requests>=2.20.0,<2.26" "requests~=2.20" \
      --replace "cachetools~=5.0.0" "cachetools~=5.0"
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
