{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "configparser";
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "005c3b102c96f4be9b8f40dafbd4997db003d07d1caa19f37808be8031475f2a";
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
