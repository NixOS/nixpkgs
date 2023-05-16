{ lib
, buildPythonPackage
, fetchPypi
, future
, mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "hcloud";
<<<<<<< HEAD
  version = "1.28.0";
=======
  version = "1.19.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-BM6iy3dSjiy65uLi1Yr1qvaWcnrE/LQfyFkZLrzD8pw=";
=======
    hash = "sha256-IKgK8UQYVPV8zm0wqmVyFDeRv0h9+1iwJ3Ih6yrXIOM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    future
    requests
    python-dateutil
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hcloud"
  ];

  meta = with lib; {
    description = "Library for the Hetzner Cloud API";
    homepage = "https://github.com/hetznercloud/hcloud-python";
    changelog = "https://github.com/hetznercloud/hcloud-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ liff ];
  };
}
