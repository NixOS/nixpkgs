{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, msgpack
, pytest
}:

buildPythonPackage rec {
  version = "0.12.5";
  pname = "CacheControl";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cef77effdf51b43178f6a2d3b787e3734f98ade253fa3187f3bb7315aaa42ff7";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ requests msgpack ];

  # tests not included with pypi release
  doCheck = false;

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ionrock/cachecontrol;
    description = "Httplib2 caching for requests";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
