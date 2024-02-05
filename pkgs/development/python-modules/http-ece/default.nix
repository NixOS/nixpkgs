{ lib, fetchPypi, buildPythonPackage, pythonOlder
, coverage, flake8, mock, nose, importlib-metadata
, cryptography }:

buildPythonPackage rec {
  pname = "http_ece";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tZIPjvuOG1+wJXE+Ozb9pUM2JiAQY0sm3B+Y+F0es94=";
  };

  propagatedBuildInputs = [ cryptography ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ coverage flake8 mock nose ];

  meta = with lib; {
    description = "Encipher HTTP Messages";
    homepage = "https://github.com/martinthomson/encrypted-content-encoding";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
