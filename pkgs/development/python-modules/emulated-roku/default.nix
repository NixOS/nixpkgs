{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, aiohttp
}:

buildPythonPackage rec {
  pname = "emulated-roku";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mindigmarton";
    repo = "emulated_roku";
    rev = version;
    hash = "sha256-7DbJl1e1ESWPCNuQX7m/ggXNDyPYZ5eNGwSz+jnxZj0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "emulated_roku" ];

  meta = with lib; {
    description = "Library to emulate a roku server to serve as a proxy for remotes such as Harmony";
    homepage = "https://github.com/mindigmarton/emulated_roku";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
