{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, unasync
, boto3
, botocore
, requests
, aiohttp
, pyquery
, loguru
}:

buildPythonPackage rec {
  pname = "pyhiveapi";
  version = "0.5.16";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Pyhass";
    repo = "Pyhiveapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-gPou5KGLFEFP29qSpRg+6sCiXOwfoF1gyhBVERYJ1LI=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pre-commit" ""
  '';

  nativeBuildInputs = [
    setuptools
    unasync
  ];

  propagatedBuildInputs = [
    boto3
    botocore
    requests
    aiohttp
    pyquery
    loguru
  ];

  # tests are not functional yet
  doCheck = false;

  postBuild = ''
    # pyhiveapi accesses $HOME upon importing
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "pyhiveapi" ];

  meta = with lib; {
    description = "Python library to interface with the Hive API";
    homepage = "https://github.com/Pyhass/Pyhiveapi";
    changelog = "https://github.com/Pyhass/Pyhiveapi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
