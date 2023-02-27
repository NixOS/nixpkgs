{ lib, fetchPypi, buildPythonPackage, pythonOlder
, coverage, flake8, mock, nose, importlib-metadata
, cryptography }:

buildPythonPackage rec {
  pname = "http_ece";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y5ln09ji4dwpzhxr77cggk02kghq7lql60a6969a5n2lwpvqblk";
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
