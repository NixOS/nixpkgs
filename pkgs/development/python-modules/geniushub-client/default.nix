{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "geniushub-client";
  version = "0.6.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "390932b6e5051e221d104b2683d9deb6e352172c4ec4eeede0954bf2f9680211";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # tests only implemented after 0.6.30
  doCheck = false;

  pythonImportsCheck = [ "geniushubclient" ];

  meta = with lib; {
    description = "Aiohttp-based client for Genius Hub systems";
    homepage = "https://github.com/zxdavb/geniushub-client";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
