{
  buildPythonPackage,
  click,
  foundrytools,
  loguru,
  pathvalidate,
  rich,
  lib,
  uv,
  uv-build,
  wheel,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "foundrytools_cli";
  version = "2.0.4";
  pyproject = true;

  nativeBuildInputs = [
    uv
    uv-build
    wheel
  ];

  propagatedBuildInputs = [
    click
    foundrytools
    loguru
    pathvalidate
    rich
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gmt4GqRPs4y+CjofaBPuwaSUAZkDMMC3NpXA4x+pfuQ=";
  };
  meta = {
    description = "A set of command line tools to inspect, manipulate and convert font files";
    homepage = "https://github.com/ftCLI/FoundryTools-CLI";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      qb114514
    ];
  };
}
