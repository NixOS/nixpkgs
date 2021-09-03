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
  version = "1.1.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n2vzyrirfj7fp0zn6iipm3i8bch0g4m14z02nrvlyjiyfmi7zmq";
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
