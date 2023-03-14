{ lib, buildPythonPackage, fetchPypi,
  six, pytest, pytest-runner, pytest-cov, coverage
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

  nativeCheckInputs = [ pytest pytest-runner pytest-cov coverage ];
  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "https://github.com/schwehr/libais";
    description = "Library for decoding maritime Automatic Identification System messages";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
