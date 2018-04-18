{ lib, buildPythonPackage, fetchPypi, python
, mock, testrepository, testtools
, requests, six }:

buildPythonPackage rec {
  pname = "requests-mock";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2931887853c42e1d73879983d5bf03041109472991c5b4b8dba5d11ed23b9d0b";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  checkInputs = [ mock testrepository testtools ];

  propagatedBuildInputs = [ requests six ];
}
