{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm }:

buildPythonPackage rec {
  pname = "configparser";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7d282687a5308319bf3d2e7706e575c635b0a470342641c93bea0ea3b5331df";
  };

  # No tests available
  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];

  preConfigure = ''
    export LC_ALL=${if stdenv.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with stdenv.lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+.";
    license = licenses.mit;
    homepage = https://github.com/jaraco/configparser;
  };
}
