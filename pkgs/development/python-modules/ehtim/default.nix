{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, astropy
, matplotlib
, ephem
, h5py
, pandas
, requests
, future
}:

buildPythonPackage rec {
  pname = "ehtim";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "achael";
    repo = "eht-imaging";
    rev = "v${version}";
    sha256 = "ZeacOUve1QHX4Ei61GHEMtbqyfOV7Cj9q7+sH/lQR+w=";
  };

  propagatedBuildInputs = [
    numpy scipy astropy matplotlib ephem h5py pandas requests future
  ];

  doCheck = false;  # Tests require additional data
  pythonImportsCheck = [ "ehtim" ];

  meta = with lib; {
    homepage = "https://achael.github.io/eht-imaging";
    description = ''
      Python modules for simulating and manipulating VLBI data and
      producing images with regularized maximum likelihood methods
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ parras ];
  };
}
