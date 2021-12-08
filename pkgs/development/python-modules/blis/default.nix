{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, hypothesis
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "blis";
  version = "0.7.5";

  src = fetchFromGitHub {
     owner = "explosion";
     repo = "cython-blis";
     rev = "v0.7.5";
     sha256 = "18npb3z8xqhs9ka2h55inzs1pdvqpss3p5fq30cv8jzfmlgwdc6l";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];


  checkInputs = [
    hypothesis
    pytest
  ];

  meta = with lib; {
    description = "BLAS-like linear algebra library";
    homepage = "https://github.com/explosion/cython-blis";
    license = licenses.bsd3;
    platforms = platforms.x86_64;
  };
}
