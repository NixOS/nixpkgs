{ lib, buildPythonPackage, fetchPypi
, requests
, py
, pytestCheckHook
, lazy
}:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y4LSWo6sbHn239qSdQjwfZO4cyNyoGFQVVGvZbRgYfQ=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--flake8" ""
  '';

  propagatedBuildInputs = [
    requests
    py
    lazy
  ];

  checkInputs = [
    py
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/devpi/devpi";
    description = "Utilities jointly used by devpi-server and devpi-client";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };
}
