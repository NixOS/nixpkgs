{ buildPythonPackage, fetchPypi, python
, mock, testrepository, testtools
, requests, six }:

buildPythonPackage rec {
  pname = "requests-mock";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a029fe6c5244963ef042c6224ff787049bfc5bab958a1b7e5b632ef0bbb05de4";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  checkInputs = [ mock testrepository testtools ];

  propagatedBuildInputs = [ requests six ];
}
