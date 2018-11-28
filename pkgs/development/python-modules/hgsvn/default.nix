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
  version = "0.3.11";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0yvhwdh8xx8rvaqd3pnnyb99hfa0zjdciadlc933p27hp9rf880p";
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
