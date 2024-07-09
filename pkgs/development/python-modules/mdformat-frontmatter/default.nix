{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  linkify-it-py,
  markdown-it-py,
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
    rev = "refs/tags/v${version}";
    hash = "sha256-2heQw8LL/ILY36oItBeQq33qjVBGT51qGG4CcCEDutA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
    ruamel-yaml
  ];

  pythonImportsCheck = [ "mdformat_frontmatter" ];

  meta = with lib; {
    description = "Mdformat plugin to ensure frontmatter is respected";
    homepage = "https://github.com/butler54/mdformat-frontmatter";
    changelog = "https://github.com/butler54/mdformat-frontmatter/blob/v{version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      aldoborrero
      polarmutex
    ];
  };
}
