{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pymiele";
  version = "0.1.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nlilHcBdWpCIknhE/RRvcmuz1waNdmcPt++Vi3amvHg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "pymiele"
  ];

  meta = with lib; {
    changelog = "https://github.com/astrandb/pymiele/releases/tag/v${version}";
    description = "Lib for Miele integration with Home Assistant";
    homepage = "https://github.com/astrandb/pymiele";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
