{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, bz2file
, mock
, nose
, numpy
, six
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83ecac4773ece02c49c364d99b465644c17cc66f1719560117e74991d9eb566b";
  };

  propagatedBuildInputs = [
    numpy
    six
  ] ++ lib.optional (!isPy3k) bz2file;

  checkInputs = [ nose mock ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = https://nipy.org/nibabel/;
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
