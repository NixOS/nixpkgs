{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, flask
, karton-core
, mistune
, networkx
, prometheus-client
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "karton-dashboard";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-O7Wrl9+RWkHPO0+9aue1Nlv0263qX8Thnh5FmnoKjxU=";
  };

=======
    hash = "sha256-XMyQ0mRF4y61hqlqdxC+He+697P1URfOXQUMnV0pT7o=";
  };

  patches = [
    # Allow later mistune, https://github.com/CERT-Polska/karton-dashboard/pull/68
    (fetchpatch {
      name = "update-mistune.patch";
      url = "https://github.com/CERT-Polska/karton-dashboard/commit/d0a2a1ffd21e9066acca77434acaff7b20e460d0.patch";
      hash = "sha256-LOqeLWoCXmVTthruBiQUYR03yPOPHhgYF/fJMhhT6Wo=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonRelaxDeps = [
    "Flask"
    "mistune"
    "networkx"
    "prometheus-client"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    flask
    karton-core
    mistune
    networkx
    prometheus-client
  ];

  # Project has no tests. pythonImportsCheck requires MinIO configuration
  doCheck = false;

  meta = with lib; {
    description = "Web application that allows for Karton task and queue introspection";
    homepage = "https://github.com/CERT-Polska/karton-dashboard";
    changelog = "https://github.com/CERT-Polska/karton-dashboard/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
