{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-cov
, watchdog
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3818f53dabc24da66f65cf4878c1c7a9b5df0c46b813e014abdd7c569eb9a02a";
  };

  # FIXME: watchdog dependency is disabled on Darwin because of #31865, which causes very silent
  # segfaults in the testsuite that end up failing the tests in a background thread (in myapp)
  checkInputs = [ pytestCheckHook pytest-cov ] ++ lib.optional (!stdenv.isDarwin) watchdog;

  meta = with lib; {
    description = "in-process file monitor / reloader for reloading your code automatically during development";
    homepage = "https://github.com/Pylons/hupper";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
