{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytest-sugar, pytest-warnings, setuptools_scm
, tempora }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "portend";
  version = "2.1.2";

  buildInputs = [ pytest pytest-sugar pytest-warnings setuptools_scm ];
  propagatedBuildInputs = [ tempora ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dx8b1rn64ymx5s4mdzlw5hz59qi167z7nny36dl75ghlldn41w4";
  };

  meta = with stdenv.lib; {
    description = "Monitor TCP ports for bound or unbound states";
    homepage = https://github.com/jaraco/portend;
    license = licenses.bsd3;
  };
}
