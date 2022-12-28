{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, appdirs
, lxml
, packaging
, py
, pytestCheckHook
, pythonOlder
, wireshark-cli
}:

buildPythonPackage rec {
  pname = "pyshark";
  version = "0.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KimiNewt";
    repo = pname;
    rev = "refs/tags/v${version}";
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

  # `stripLen` does not seem to work here
  patchFlags = [ "-p2" ];

  sourceRoot = "${src.name}/src";

  # propagate wireshark, so pyshark can find it when used
  propagatedBuildInputs = [ appdirs py lxml packaging wireshark-cli ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [ pytestCheckHook wireshark-cli ];

  pythonImportsCheck = [ "pyshark" ];

  pytestFlagsArray = [ "../tests/" ];

  meta = with lib; {
    description =
      "Python wrapper for tshark, allowing Python packet parsing using Wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
