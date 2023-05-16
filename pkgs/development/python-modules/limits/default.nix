{ lib
, buildPythonPackage
, deprecated
, fetchFromGitHub
, etcd3
, hiro
<<<<<<< HEAD
, importlib-resources
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, pymemcache
, pymongo
, pytest-asyncio
, pytest-lazy-fixture
, pytestCheckHook
, pythonOlder
, redis
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "limits";
<<<<<<< HEAD
  version = "3.5.0";
=======
  version = "3.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = pname;
    rev = "refs/tags/${version}";
    # Upstream uses versioneer, which relies on git attributes substitution.
    # This leads to non-reproducible archives on github. Remove the substituted
    # file here, and recreate it later based on our version info.
    postFetch = ''
      rm "$out/limits/_version.py"
    '';
<<<<<<< HEAD
    hash = "sha256-O4yENynvon9xM8F/r0NMSpSh6Hl2EoTcXgldrwzo24M=";
=======
    hash = "sha256-zMU2MU7MFTWSig2j1PaBLPtKM5/7gNkFajKXw3A+fIQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    deprecated
<<<<<<< HEAD
    importlib-resources
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    packaging
    setuptools
    typing-extensions
  ];

  nativeCheckInputs = [
    etcd3
    hiro
    pymemcache
    pymongo
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
    redis
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=limits" "" \
      --replace "-K" ""

    substituteInPlace setup.py \
      --replace "versioneer.get_version()" "'${version}'"

    # Recreate _version.py, deleted at fetch time due to non-reproducibility.
    echo 'def get_versions(): return {"version": "${version}"}' > limits/_version.py
  '';

  pythonImportsCheck = [
    "limits"
  ];

  pytestFlagsArray = [
    # All other tests require a running Docker instance
    "tests/test_limits.py"
    "tests/test_ratelimit_parser.py"
    "tests/test_limit_granularities.py"
  ];

  meta = with lib; {
    description = "Rate limiting using various strategies and storage backends such as redis & memcached";
    homepage = "https://github.com/alisaifee/limits";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
