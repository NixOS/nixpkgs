{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "python-xz";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OYdGWTtwb6n6xZuMmI6rhgPh/iupGVERwLRSJ6OnfbM=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "xz" ];

  meta = with lib; {
    description = "Pure Python library for seeking within compressed xz files";
    homepage = "https://github.com/Rogdham/python-xz";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = platforms.all;
  };
}
