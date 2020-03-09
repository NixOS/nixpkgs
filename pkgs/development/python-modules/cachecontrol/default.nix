{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, msgpack
, pytest
}:

buildPythonPackage rec {
  version = "0.12.6";
  pname = "CacheControl";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be9aa45477a134aee56c8fac518627e1154df063e85f67d4f83ce0ccc23688e8";
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
