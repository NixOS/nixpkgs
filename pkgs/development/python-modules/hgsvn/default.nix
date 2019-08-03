{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, hglib
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  pname = "hgsvn";
  version = "0.3.15";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "036270cc2803f7a7de3842e8c593849631b2293e647aa3444f68f1b1834d1fa1";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ hglib ];

  doCheck = false;  # too many assumptions

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/hgsvn;
    description = "A set of scripts to work locally on Subversion checkouts using Mercurial";
    license = licenses.gpl2;
  };

}
