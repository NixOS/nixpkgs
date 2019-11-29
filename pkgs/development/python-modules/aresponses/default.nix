{ lib
, buildPythonPackage
, fetchPypi
# propagatedBuildInputs
, aiohttp
# buildInputs
, pytest
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1d6ef52b9a97142d106688cf9b112602ef3dc66f6368de8f91f47241d8cfc9c";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  buildInputs = [
    pytest
    pytest-asyncio
  ];

  # tests only distributed via git repository, not pypi
  doCheck = false;

  meta = with lib; {
    description = "Asyncio testing server";
    homepage = "https://github.com/circleup/aresponses";
    license = licenses.mit;
    maintainers = [ maintainers.makefu ];
  };
}
