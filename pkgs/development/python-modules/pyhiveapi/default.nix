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
  version = "0.5.3";

  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Pyhass";
    repo = "Pyhiveapi";
    rev = "v${version}";
    hash = "sha256-QBn+yKZN461npdhGngTnFeewE40dPZ+5TkUf5Xacajk=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
