{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, flask
, pytest-runner
}:

buildPythonPackage rec {
  pname = "Flask-Gravatar";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "YGZfMcLGEokdto/4Aek+06CIHGyOw0arxk0qmSP1YuE=";
  };

  # depends on pytest-pep8 which is abandoned, not going to bother
  doCheck = false;

  preBuild = ''
    sed "s|tests_require=tests_require,||g" -i setup.py
    sed "s|extras_require=extras_require,||g" -i setup.py
    sed "s|setup_requires=setup_requires,||g" -i setup.py
  '';

  propagatedBuildInputs = [
    flask
  ];

  meta = with lib; {
    homepage = "https://github.com/zzzsochi/Flask-Gravatar";
    description = "Small and simple integration of gravatar into flask";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
