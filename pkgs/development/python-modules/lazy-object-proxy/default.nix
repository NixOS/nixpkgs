{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9723364577b79ad9958a68851fe2acb94da6fd25170c595516a8289e6a129043";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test tests
  '';

  # Broken tests. Seem to be fixed upstream according to Travis.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A fast and thorough lazy object proxy";
    homepage = "https://github.com/ionelmc/python-lazy-object-proxy";
    license = with licenses; [ bsd2 ];
  };

}
