{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, nose
}:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "python-json-logger";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "202a4f29901a4b8002a6d1b958407eeb2dd1d83c18b18b816f5b64476dde9096";
  };

  checkInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/madzak/python-json-logger";
    description = "A python library adding a json log formatter";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };

}
