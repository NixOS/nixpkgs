{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  six,
}:

buildPythonPackage rec {
  version = "0.12.0";
  format = "setuptools";
  pname = "pyfribidi";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-ZHJqSlZ4Os3HnGubOhXxbmBxB3yJeguZnztD90S8Yhw=";
  };

  patches = lib.optional stdenv.cc.isClang ./pyfribidi-clang.patch;

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Simple wrapper around fribidi";
    homepage = "https://github.com/pediapress/pyfribidi";
    license = licenses.gpl2;
  };
}
