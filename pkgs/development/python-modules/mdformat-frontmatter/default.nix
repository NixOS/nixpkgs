{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdit-py-plugins,
  ruamel-yaml,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-frontmatter";
  version = "2.0.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "butler54";
    repo = "mdformat-frontmatter";
    tag = "v${version}";
    hash = "sha256-2heQw8LL/ILY36oItBeQq33qjVBGT51qGG4CcCEDutA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
    ruamel-yaml
  ];

  pythonImportsCheck = [ "mdformat_frontmatter" ];

  meta = {
    description = "Mdformat plugin to ensure frontmatter is respected";
    homepage = "https://github.com/butler54/mdformat-frontmatter";
    changelog = "https://github.com/butler54/mdformat-frontmatter/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aldoborrero
      polarmutex
    ];
  };
}
