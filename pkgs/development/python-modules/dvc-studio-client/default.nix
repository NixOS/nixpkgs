{
  lib,
  buildPythonPackage,
  dulwich,
  fetchFromGitHub,
  gitpython,
  pythonOlder,
  requests,
  setuptools-scm,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "dvc-studio-client";
  version = "0.20.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JLrsbgifoUnN1Mwml9tO3/SkA6miE14AGjxrFwEcRks=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    dulwich
    gitpython
    requests
    voluptuous
  ];

  pythonImportsCheck = [ "dvc_studio_client" ];

  # Tests try to access network
  doCheck = false;

  meta = with lib; {
    description = "Library to post data from DVC/DVCLive to Iterative Studio";
    homepage = "https://github.com/iterative/dvc-studio-client";
    changelog = "https://github.com/iterative/dvc-studio-client/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
