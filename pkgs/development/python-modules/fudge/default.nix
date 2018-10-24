{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, nosejs
, sphinx
, isPy3k
}:

buildPythonPackage rec {
  pname = "fudge";
  version = "1.1.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eba59a926fa1df1ab6dddd69a7a8af21865b16cad800cb4d1af75070b0f52afb";
  };

  buildInputs = [ nose nosejs ];
  propagatedBuildInputs = [ sphinx ];

  checkPhase = ''
    nosetests -v
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/fudge-py/fudge;
    description = "Replace real objects with fakes (mocks, stubs, etc) while testing";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };

}
