{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, nose
}:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "python-json-logger";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f26eea7898db40609563bed0a7ca11af12e2a79858632706d835a0f961b7d398";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/madzak/python-json-logger";
    description = "A python library adding a json log formatter";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };

}
