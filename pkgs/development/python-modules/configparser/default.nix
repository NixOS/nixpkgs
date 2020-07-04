{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "configparser";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ca44140ee259b5e3d8aaf47c79c36a7ab0d5e94d70bd4105c03ede7a20ea5a1";
  };

  # No tests available
  doCheck = false;

  nativeBuildInputs = [ setuptools_scm toml ];

  preConfigure = ''
    export LC_ALL=${if stdenv.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with stdenv.lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+.";
    license = licenses.mit;
    homepage = "https://github.com/jaraco/configparser";
  };
}
