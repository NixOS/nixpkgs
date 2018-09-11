{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.1.9";
  pname = "python-json-logger";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e3636824d35ba6a15fc39f573588cba63cf46322a5dc86fb2f280229077e9fbe";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    homepage = http://github.com/madzak/python-json-logger;
    description = "A python library adding a json log formatter";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
