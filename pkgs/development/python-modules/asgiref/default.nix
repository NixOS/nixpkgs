{ lib
, stdenv
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, fetchpatch
}:

buildPythonPackage rec {
  version = "3.5.0";
  pname = "asgiref";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "sha256-eWDsd8iWK1C/X3t/fKAM1i4hyTM/daGTd8CDSgDTL/U=";
  };

  patches = [
    (fetchpatch {
      name = "remove-sock-nonblock-in-tests.patch";
      url = "https://github.com/django/asgiref/commit/d451a724c93043b623e83e7f86743bbcd9a05c45.patch";
      sha256 = "0whdsn5isln4dqbqqngvsy4yxgaqgpnziz0cndj1zdxim8cdicj7";
    })
  ];

  propagatedBuildInputs = [
    async-timeout
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_multiprocessing"
  ];

  pythonImportsCheck = [ "asgiref" ];

  meta = with lib; {
    description = "Reference ASGI adapters and channel layers";
    homepage = "https://github.com/django/asgiref";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
