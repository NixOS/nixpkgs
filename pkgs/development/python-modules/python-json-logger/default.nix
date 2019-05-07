{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.1.11";
  pname = "python-json-logger";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7a31162f2a01965a5efb94453ce69230ed208468b0bbc7fdfc56e6d8df2e281";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    homepage = https://github.com/madzak/python-json-logger;
    description = "A python library adding a json log formatter";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };

}
