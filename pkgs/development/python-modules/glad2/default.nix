{ lib
, buildPythonPackage
, fetchPypi
, jinja2
}:

buildPythonPackage rec {
  pname = "glad2";
  version = "2.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7eFjn2nyugjx9JikCnB/NKYJ0k6y6g1sk2RomnmM99A=";
  };

  propagatedBuildInputs = [
    jinja2
  ];

  # no python tests
  doCheck = false;

  pythonImportsCheck = [ "glad" ];

  meta = with lib; {
    description = "Multi-Language GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specifications";
    homepage = "https://github.com/Dav1dde/glad";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
