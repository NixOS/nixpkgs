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
  version = "2.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jn7x7ldqsz5cd190jqjil0kqyimd1d0yxfzzp41ky0p72lvd68a";
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
