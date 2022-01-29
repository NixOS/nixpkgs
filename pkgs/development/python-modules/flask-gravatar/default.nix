{ lib
, buildPythonPackage
, fetchPypi
, flask
, pytestCheckHook
, pygments
}:

buildPythonPackage rec {
  pname = "flask-gravatar";
  version = "0.5.0";

  src = fetchPypi {
    pname = "Flask-Gravatar";
    inherit version;
    sha256 = "YGZfMcLGEokdto/4Aek+06CIHGyOw0arxk0qmSP1YuE=";
  };

  postPatch = ''
    sed -i setup.py \
     -e "s|tests_require=tests_require,||g" \
     -e "s|extras_require=extras_require,||g" \
     -e "s|setup_requires=setup_requires,||g"
    # pep8 is deprecated and cov not needed
    substituteInPlace pytest.ini \
     --replace "--pep8" "" \
     --replace "--cov=flask_gravatar --cov-report=term-missing" ""
  '';

  propagatedBuildInputs = [
    flask
  ];

  checkInputs = [
    pytestCheckHook
    pygments
  ];

  pythonImportsCheck = [ "flask_gravatar" ];

  meta = with lib; {
    homepage = "https://github.com/zzzsochi/Flask-Gravatar";
    description = "Small and simple integration of gravatar into flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
