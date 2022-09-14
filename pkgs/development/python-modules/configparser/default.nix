{ lib, stdenv, buildPythonPackage, fetchPypi, setuptools-scm }:

buildPythonPackage rec {
  pname = "configparser";
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i+JngktUHAmwjbEkkX9Iq1JabD6DcBHzEweBoiTFcJA=";
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
