{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
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
  version = "0.4.3";

  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Pyhass";
    repo = "Pyhiveapi";
    rev = "v${version}";
    sha256 = "sha256-SCMASYBOdq9nko5RSQ5BEbRLjOB4FlgwOKwdDggiOv8=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pre-commit" ""
  '';

  nativeBuildInputs = [
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
