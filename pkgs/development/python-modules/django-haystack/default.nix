{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi

# build dependencies
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm

# dependencies
, django

# tests
<<<<<<< HEAD
, elasticsearch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, geopy
, nose
, pysolr
, python-dateutil
, requests
, whoosh
}:

buildPythonPackage rec {
  pname = "django-haystack";
  version = "3.2.1";
<<<<<<< HEAD
  format = "pyproject";

=======
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l+MZeu/CJf5AW28XYAolNL+CfLTWdDEwwgvBoG9yk6Q=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "geopy==" "geopy>="
  '';

  nativeBuildInputs = [
<<<<<<< HEAD
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    django
  ];

  passthru.optional-dependencies = {
    elasticsearch = [
      elasticsearch
    ];
  };

  doCheck = lib.versionOlder django.version "4";

=======
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    geopy
    nose
    pysolr
    python-dateutil
    requests
    whoosh
<<<<<<< HEAD
  ]
  ++ passthru.optional-dependencies.elasticsearch;

  checkPhase = ''
    runHook preCheck
    python test_haystack/run_tests.py
    runHook postCheck
  '';
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Pluggable search for Django";
    homepage = "http://haystacksearch.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
