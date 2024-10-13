{
  lib,
  stdenv,
  boost,
  buildPythonPackage,
  exiv2,
  fetchPypi,
  libcxx,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "py3exiv2";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-crI+X3YMRzPPmpGNsI2U+9bZgwcR0qTowJuPNFY/Ooo=";
  };

  buildInputs = [
    boost
    exiv2
  ];

  # Work around Python distutils compiling C++ with $CC (see issue #26709)
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  pythonImportsCheck = [ "pyexiv2" ];

  # Tests are not shipped
  doCheck = false;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Python binding to the library exiv2";
    homepage = "https://launchpad.net/py3exiv2";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vinymeuh ];
    platforms = with platforms; linux ++ darwin;
  };
}
