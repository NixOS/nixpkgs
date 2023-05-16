{ lib
<<<<<<< HEAD
, buildPythonPackage
, certifi
, fetchPypi
, openssl
, pylsqpack
, pyopenssl
, pytestCheckHook
, pythonOlder
=======
, fetchPypi
, fetchpatch
, buildPythonPackage
, openssl
, pylsqpack
, certifi
, pytestCheckHook
, pyopenssl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aioquic";
<<<<<<< HEAD
  version = "0.9.21";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ecfsBjGOeFYnZlyk6HI63zR7ciW30AbjMtJXWh9RbvU=";
  };

=======
  version = "0.9.20";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7ENqqs6Ze4RrAeUgDtv34+VrkYJqFE77l0j9jd0zK74=";
  };

  patches = [
    # This patch is here because it's required by the next patch.
    (fetchpatch {
      url = "https://github.com/aiortc/aioquic/commit/3930580b50831a034d21ee4689362188b21a4d6a.patch";
      hash = "sha256-XjhyajDawN/G1nPtkMbNe66iJCo76UpdA7PqwtxO5ag=";
    })
    # https://github.com/aiortc/aioquic/pull/349, fixes test failure due pyopenssl==22
    (fetchpatch {
      url = "https://github.com/aiortc/aioquic/commit/c3b72be85868d67ee32d49ab9bd98a4357cbcde9.patch";
      hash = "sha256-AjW+U9DpNXgA5yqKkWnx0OYpY2sZR9KIdQ3pSzxU+uY=";
    })
    # AssertionError: 'self-signed certificate' != 'self signed certificate'
    (fetchpatch {
      url = "https://github.com/aiortc/aioquic/commit/cfcd3ce12fb27f5b26deb011a82f66b5d68d521a.patch";
      hash = "sha256-bCW817Z7jCxYySfUukNR4cibURH3qZWEQjeeyvRIqZY=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    certifi
    pylsqpack
    pyopenssl
  ];

<<<<<<< HEAD
  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioquic"
  ];
=======
  buildInputs = [ openssl ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aioquic" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Implementation of QUIC and HTTP/3";
    homepage = "https://github.com/aiortc/aioquic";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
