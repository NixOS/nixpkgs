{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, isPy27
, bz2file
, mock
, nose
, numpy
, six
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "3.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f5bc325c9cb203c6f0ab876ba1a5ada811284bb3a4c5d063eeaafaefbad873d";
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
