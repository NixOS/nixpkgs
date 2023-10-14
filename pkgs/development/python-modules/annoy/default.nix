{ lib
, buildPythonPackage
, fetchPypi
, h5py
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "annoy";
  version = "1.17.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nL/r7+Cl+EPropxr5MhNYB9PQa1N7QSG8biMOwdznBU=";
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
    changelog = "https://github.com/spotify/annoy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
