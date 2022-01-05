{ lib, stdenv, buildPythonPackage, fetchPypi, setuptools-scm }:

buildPythonPackage rec {
  pname = "configparser";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "202b9679a809b703720afa2eacaad4c6c2d63196070e5d9edc953c0489dfd536";
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
