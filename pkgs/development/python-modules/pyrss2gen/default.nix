{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyrss2gen";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyRSS2Gen";
    inherit version;
    hash = "sha256-eWCu1+mY0kgr9YcWwxZQl4b1lkJvh5sF+NhOmLgsbuc=";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.dalkescientific.om/Python/PyRSS2Gen.html";
    description = "Library for generating RSS 2.0 feeds";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
