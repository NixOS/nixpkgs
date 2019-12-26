{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3900e8a5de27447acbf900b4750b0ddfd7ec1ea7fbaf11dfa911141bc522af0";
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
    homepage = https://github.com/ionelmc/python-lazy-object-proxy;
    license = with licenses; [ bsd2 ];
  };

}
