{ lib
, buildPythonPackage
, fetchPypi
, requests
, msgpack
, pytest
}:

buildPythonPackage rec {
  version = "0.12.8";
  pname = "CacheControl";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JUBDwbq3SMicCaiQ+RKKD7LGVOlGvPRzwS0p/fnLbFs=";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ requests msgpack ];

  # tests not included with pypi release
  doCheck = false;

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/ionrock/cachecontrol";
    description = "Httplib2 caching for requests";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
