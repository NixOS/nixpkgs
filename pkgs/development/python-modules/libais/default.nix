{ stdenv, buildPythonPackage, fetchPypi,
  six, pytest, pytestrunner, pytestcov, coverage
}:
buildPythonPackage rec {
  pname = "libais";
  version = "0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pyka09h8nb0vlzh14npq4nxmzg1046lr3klgn97dsf5k0iflapb";
  };

  # data files missing
  doCheck = false;

  checkInputs = [ pytest pytestrunner pytestcov coverage ];
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/schwehr/libais;
    description = "Library for decoding maritime Automatic Identification System messages";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
