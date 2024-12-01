{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  importlib-metadata,
  importlib-resources,
  jinja2,
  mkdocs,
  pythonOlder,
  pyyaml,
  unittestCheckHook,
  verspec,
}:

buildPythonPackage rec {
  pname = "mike";
  version = "unstable-2023-05-06";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jimporter";
    repo = pname;
    rev = "300593c338b18f61f604d18457c351e166318020";
    hash = "sha256-Sjj2275IJDtLjG6uO9h4FbgxXTMgqD8c/rJj6iOxfuI=";
  };

  propagatedBuildInputs = [
    importlib-metadata
    importlib-resources
    jinja2
    mkdocs
    pyyaml
    verspec
  ];

  nativeCheckInputs = [
    git
    unittestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  # Difficult to setup
  doCheck = false;

  pythonImportsCheck = [ "mike" ];

  meta = with lib; {
    description = "Manage multiple versions of your MkDocs-powered documentation";
    mainProgram = "mike";
    homepage = "https://github.com/jimporter/mike";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
