{ lib
, buildPythonPackage
, fetchPypi
, h5py
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "annoy";
  version = "1.17.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vxd9vq+4H2OyrB4SRrHyairMguc7pGY4c00p2CWBIto=";
  };

  nativeBuildInputs = [
    h5py
  ];

  nativeCheckInputs = [
    nose
  ];

  pythonImportsCheck = [
    "annoy"
  ];

  meta = with lib; {
    description = "Approximate Nearest Neighbors in C++/Python optimized for memory usage and loading/saving to disk";
    homepage = "https://github.com/spotify/annoy";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
