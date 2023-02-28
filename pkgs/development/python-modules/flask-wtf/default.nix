{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, flask
, itsdangerous
, wtforms
, email-validator
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-wtf";
  version = "1.1.1";

  src = fetchPypi {
    pname = "Flask-WTF";
    inherit version;
    sha256 = "sha256-QcQkTprmJtY77UKuR4W5Bme4hbFTXVpAleH2MGDRKqk=";
  };

 patches = [
    # Fix failing `test_set_default_message_language` test
    #
    # Caused by Flask 2.2 that throws an error when setup methods are
    # mistakenly called before the first request.
    #
    # Will be fixed upstream with: https://github.com/wtforms/flask-wtf/pull/533
    #
    (fetchpatch {
      url = "https://github.com/wtforms/flask-wtf/commit/36a53fadf7bc42c79a1428657531961ec30ca003.patch";
      hash = "sha256-bgLwDG9Wpufm6fd/6PS83Jvvuk1Ha6XdyaWngluPs30=";
    })
  ];

  propagatedBuildInputs = [
    flask
    itsdangerous
    wtforms
  ];

  passthru.optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple integration of Flask and WTForms.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 anthonyroussel ];
    homepage = "https://github.com/lepture/flask-wtf/";
  };
}
