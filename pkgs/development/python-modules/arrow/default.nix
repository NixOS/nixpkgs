{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python-dateutil
, typing-extensions
, pytestCheckHook
, pytest-mock
, pytz
, simplejson
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "1.2.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2dde3c382d9f7e6922ce636bf0b318a7a853df40ecb383b29192e6c5cc82840";
  };

  postPatch = ''
    # no coverage reports
    sed -i "/addopts/d" tox.ini
  '';

  propagatedBuildInputs = [ python-dateutil ]
    ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pytz
    simplejson
  ];

  # ParserError: Could not parse timezone expression "America/Nuuk"
  disabledTests = [
    "test_parse_tz_name_zzz"
  ];

  pythonImportsCheck = [ "arrow" ];

  meta = with lib; {
    description = "Python library for date manipulation";
    homepage = "https://github.com/crsmithdev/arrow";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
