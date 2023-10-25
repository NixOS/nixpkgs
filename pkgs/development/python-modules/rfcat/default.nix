{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, future
, ipython
, numpy
, pyserial
, pyusb
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rfcat";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "atlas0fd00m";
    repo = "rfcat";
    rev = "refs/tags/v${version}";
    hash = "sha256-hdRsVbDXRC1EOhBoFJ9T5ZE6hwOgDWSdN5sIpxJ0x3E=";
  };

  propagatedBuildInputs = [
    future
    ipython
    numpy
    pyserial
    pyusb
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/etc/udev/rules.d
    cp etc/udev/rules.d/20-rfcat.rules $out/etc/udev/rules.d
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rflib"
  ];

  meta = with lib; {
    description = "Swiss Army knife of sub-GHz ISM band radio";
    homepage = "https://github.com/atlas0fd00m/rfcat";
    license = licenses.bsd3;
    maintainers = with maintainers; [ trepetti ];
    changelog = "https://github.com/atlas0fd00m/rfcat/releases/tag/v${version}";
  };
}
