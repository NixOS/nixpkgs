{ lib, stdenv, buildPythonPackage, fetchPypi, setuptools-scm }:

buildPythonPackage rec {
  pname = "configparser";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "85d5de102cfe6d14a5172676f09d19c465ce63d6019cf0a4ef13385fc535e828";
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
