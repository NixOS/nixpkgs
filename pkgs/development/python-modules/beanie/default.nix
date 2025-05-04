{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  flit,
  pydantic,
  motor,
  click,
toml,
lazy-model,
typing-extensions,
}:

buildPythonPackage rec {
  pname = "beanie";
  version = "1.29.0";
  pyproject = true;

  build-system = [
    flit
  ];

  src = fetchFromGitHub {
    owner = "BeanieODM";
    repo = "beanie";
    tag = version;
    hash = "";
  };

  dependencies =[pydantic motor click toml lazy-model typing-extensions];

}
