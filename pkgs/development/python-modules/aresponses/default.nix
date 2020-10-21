{ lib
, buildPythonPackage
, fetchPypi
# propagatedBuildInputs
, aiohttp
# buildInputs
, pytest
, pytest-asyncio
, isPy3k
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "2.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "58693a6b715edfa830a20903ee1d1b2a791251923f311b3bebf113e8ff07bb35";
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
