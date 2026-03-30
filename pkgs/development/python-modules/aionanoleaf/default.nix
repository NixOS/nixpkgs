{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "aionanoleaf";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = "aionanoleaf";
    tag = "v${version}";
    hash = "sha256-f0TyXhuAzI0s0n6sXH9mKWA4nad2YchZkQ0+jw/Bmv0=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aionanoleaf" ];

  meta = {
    description = "Python wrapper for the Nanoleaf API";
    homepage = "https://github.com/milanmeu/aionanoleaf";
    changelog = "https://github.com/milanmeu/aionanoleaf/releases/tag/v${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
