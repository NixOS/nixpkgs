{ lib
, buildPythonPackage
, fetchPypi
, h5py
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "annoy";
  version = "1.17.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5nv7uDfRMG2kVVyIOGDHshXLMqhk5AAiKS1YR60foLs=";
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
