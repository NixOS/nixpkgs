{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aionanoleaf";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-f0TyXhuAzI0s0n6sXH9mKWA4nad2YchZkQ0+jw/Bmv0=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aionanoleaf" ];

  meta = with lib; {
    description = "Python wrapper for the Nanoleaf API";
    homepage = "https://github.com/milanmeu/aionanoleaf";
    changelog = "https://github.com/milanmeu/aionanoleaf/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
