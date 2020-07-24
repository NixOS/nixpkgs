{ lib
, blas
, lapack
, buildPythonPackage
, cffi
, fetchFromGitHub
, nose
, numpy
}:

buildPythonPackage {
  pname = "prox-tv";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "albarji";
    repo = "proxTV";
    rev = "e621585d5aaa7983fbee68583f7deae995d3bafb";
    sha256 = "0mlrjbb5rw78dgijkr3bspmsskk6jqs9y7xpsgs35i46dvb327q5";
  };

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    numpy
    cffi
  ];

  buildInputs = [ blas lapack ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/albarji/proxTV";
    description = "A toolbox for fast Total Variation proximity operators";
    license = licenses.bsd2;
    maintainers = with maintainers; [ multun ];
  };
}
