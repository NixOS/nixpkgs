{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, scikit-learn
, torch
, apricot-select
, networkx
, pytestCheckHook
, nose
}:


buildPythonPackage rec {
  pname = "pomegranate";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jmschrei";
    repo = pname;
    rev = "d9d3748c6a7e433c4661231a9dcd2c9ef19071fc"; # release is not tagged
    hash = "sha256-jShhC77HwZ9uzBDUGMacs1ms+Yww+AZeTi1vj7SRO1c=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
    torch
    apricot-select
    networkx
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    nose
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
