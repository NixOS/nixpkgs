{ lib
<<<<<<< HEAD
, stdenv
, appdirs
, buildPythonPackage
, fetchFromGitHub
=======
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, appdirs
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, lxml
, packaging
, py
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, termcolor
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wireshark-cli
}:

buildPythonPackage rec {
  pname = "pyshark";
<<<<<<< HEAD
  version = "0.6";
=======
  version = "0.5.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KimiNewt";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-kzJDzUK6zknUyXPdKc4zMvWim4C5NQCSJSS45HI6hKM=";
  };

=======
    hash = "sha256-byll2GWY2841AAf8Xh+KfaCOtMGVKabTsLCe3gCdZ1o=";
  };

  patches = [
    (fetchpatch {
      name = "fix-mapping.patch";
      url =
        "https://github.com/KimiNewt/pyshark/pull/608/commits/c2feb17ef621390481d6acc29dbf807d6851ed4c.patch";
      hash = "sha256-TY09HPxqJP3zI8+ugm518aMuBgog7wrXs5uoReHHaEI=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # `stripLen` does not seem to work here
  patchFlags = [ "-p2" ];

  sourceRoot = "${src.name}/src";

  # propagate wireshark, so pyshark can find it when used
<<<<<<< HEAD
  propagatedBuildInputs = [
    appdirs
    lxml
    packaging
    py
    termcolor
    wireshark-cli
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    wireshark-cli
  ];
=======
  propagatedBuildInputs = [ appdirs py lxml packaging wireshark-cli ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

<<<<<<< HEAD
  disabledTests = [
    # flaky
    # KeyError: 'Packet of index 0 does not exist in capture'
    "test_getting_packet_summary"
  ] ++ lib.optionals stdenv.isDarwin [
    # fails on darwin
    # _pickle.PicklingError: logger cannot be pickled
    "test_iterate_empty_psml_capture"
  ];

  pythonImportsCheck = [
    "pyshark"
  ];

  pytestFlagsArray = [
    "../tests/"
  ];

  meta = with lib; {
    description = "Python wrapper for tshark, allowing Python packet parsing using Wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
    changelog = "https://github.com/KimiNewt/pyshark/releases/tag/${version}";
=======
  nativeCheckInputs = [ py pytestCheckHook wireshark-cli ];

  pythonImportsCheck = [ "pyshark" ];

  pytestFlagsArray = [ "../tests/" ];

  meta = with lib; {
    description =
      "Python wrapper for tshark, allowing Python packet parsing using Wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
