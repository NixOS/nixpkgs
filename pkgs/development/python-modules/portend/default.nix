{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm, tempora }:

buildPythonPackage rec {
  pname = "portend";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc48d3d99e1eaf2e9406c729f8848bfdaf87876cd3560dc3ec6c16714f529586";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ tempora ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Monitor TCP ports for bound or unbound states";
    homepage = https://github.com/jaraco/portend;
    license = licenses.bsd3;
  };
}
