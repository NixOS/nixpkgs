{ lib, stdenv, buildPythonPackage, fetchPypi, setuptools-scm }:

buildPythonPackage rec {
  pname = "configparser";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b35798fdf1713f1c3139016cfcbc461f09edbf099d1fb658d4b7479fcaa3daa";
  };

  # No tests available
  doCheck = false;

  nativeBuildInputs = [ setuptools-scm ];

  preConfigure = ''
    export LC_ALL=${if stdenv.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+.";
    license = licenses.mit;
    homepage = "https://github.com/jaraco/configparser";
  };
}
