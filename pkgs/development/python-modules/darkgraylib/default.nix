{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # dependencies
  toml,
}:

buildPythonPackage rec {
  pname = "darkgraylib";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akaihola";
    repo = "darkgraylib";
    tag = "v${version}";
    hash = "sha256-C5uIHtjrle+HS8gqxAw6pAB1rLN2WL47Aa/MwuvZc6w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    toml
  ];

  meta = {
    homepage = "https://github.com/akaihola/darkgraylib";
    description = "Common library for darker and graylint";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hackeryarn ];
  };
}
