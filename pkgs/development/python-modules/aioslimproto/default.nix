{ lib
<<<<<<< HEAD
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pillow
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
=======
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aioslimproto";
<<<<<<< HEAD
  version = "2.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.10";
=======
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-d+PEzCF1Cw/7NmumxIRRlr3hojpNsZM/JMQ0KWdosXk=";
  };

  patches = [
    # https://github.com/home-assistant-libs/aioslimproto/pull/189
    (fetchpatch {
      name = "unpin-setuptools-version.patch";
      url = "https://github.com/home-assistant-libs/aioslimproto/commit/06fd56987be8903ff147bad38af84b21bc31bc18.patch";
      hash = "sha256-kTu1+IwDrcdqelyK/vfhxw8MQBis5I1jag7YTytKQhs=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    async-timeout
    pillow
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

=======
    hash = "sha256-3aLAAUaoGkdzjUHFb6aiyVv0fzO8DojN0Y3DTf6h2Ow=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: assert ['mixer', 'volume', '50'] == ['volume', '50']
    "test_msg_instantiation"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "aioslimproto"
  ];

  meta = with lib; {
    description = "Module to control Squeezebox players";
    homepage = "https://github.com/home-assistant-libs/aioslimproto";
    changelog = "https://github.com/home-assistant-libs/aioslimproto/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
