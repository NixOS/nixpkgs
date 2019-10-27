{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, isPy3k
}:

buildPythonPackage rec {
  pname = "fudge";
  version = "1.1.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p7g6hv9qxscbzjv2n5pczpkkp55mp3s56adfc912w9qpf3rv4nr";
  };

  checkInputs = [ nose ];

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
