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
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07v1gsq1v43v0z06cnp82ij9sqx3972c9bc6vsdj7pa9ddpa2yjw";
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
