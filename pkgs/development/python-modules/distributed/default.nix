{ lib
, buildPythonPackage
, click
, cloudpickle
, dask
, fetchFromGitHub
, jinja2
, locket
, msgpack
, packaging
, psutil
, pythonOlder
, pyyaml
, setuptools
, setuptools-scm
, sortedcontainers
, tblib
, toolz
, tornado
, urllib3
, versioneer
, wheel
, zict
}:

buildPythonPackage rec {
  pname = "distributed";
<<<<<<< HEAD
  version = "2023.8.1";
=======
  version = "2023.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-HJyqDi5MqxEjAWWv8ZqNGAzeFn5rZGPwiDz5KaCm6Xk=";
=======
    hash = "sha256-KCgftu3i8N0WSelHiqWqa1vLN5gUtleftSUx1Zu4nZg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace "versioneer[toml]==" "versioneer[toml]>=" \
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    versioneer
<<<<<<< HEAD
  ] ++ versioneer.optional-dependencies.toml;
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    click
    cloudpickle
    dask
    jinja2
    locket
    msgpack
    packaging
    psutil
    pyyaml
    sortedcontainers
    tblib
    toolz
    tornado
    urllib3
    zict
  ];

  # When tested random tests would fail and not repeatably
  doCheck = false;

  pythonImportsCheck = [
    "distributed"
  ];

  meta = with lib; {
    description = "Distributed computation in Python";
    homepage = "https://distributed.readthedocs.io/";
    changelog = "https://github.com/dask/distributed/blob/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ teh ];
=======
    maintainers = with maintainers; [ teh costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
