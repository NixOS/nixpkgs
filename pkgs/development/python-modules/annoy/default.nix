{ lib
, buildPythonPackage
, fetchPypi
, h5py
, nose
}:

buildPythonPackage rec {
  version = "1.17.1";
  pname = "annoy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vxd9vq+4H2OyrB4SRrHyairMguc7pGY4c00p2CWBIto=";
  };

  nativeBuildInputs = [ h5py ];

  checkInputs = [
    nose
  ];

  meta = with lib; {
    description = "Approximate Nearest Neighbors in C++/Python optimized for memory usage and loading/saving to disk";
    homepage = "https://github.com/spotify/annoy";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
