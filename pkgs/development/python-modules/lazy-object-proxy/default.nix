{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd135b8d35dfdcdb984828c84d695937e58cc5f49e1c854eb311c4d6aa03f4f1";
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
