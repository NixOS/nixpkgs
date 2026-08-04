{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycoingecko";
  version = "3.2.0";
  src = fetchFromGitHub {
    owner = "man-c";
    repo = "pycoingecko";
    tag = finalAttrs.version;
    hash = "sha256-ltqOp33t3jgofqT8NkDV/dy6qbn9e5vxkdLNn2ERpq8=";
  };
  pyproject = true;
  build-system = [ setuptools ];
  dependencies = [ requests ];
  meta = {
    description = "Python wrapper around the CoinGecko API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
