{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "eradicate";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "092zmck919bn6sl31ixrzhn88g9nvhwzmwzpq8dzgn6c8k2h3bzr";
  };

  meta = with lib; {
    description = "eradicate removes commented-out code from Python files.";
    homepage = https://github.com/myint/eradicate;
    license = [ licenses.mit ];

    maintainers = [ maintainers.mmlb ];
  };
}
