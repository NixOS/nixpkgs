{ stdenv, lib, buildPythonPackage, fetchFromGitHub, fetchpatch, keyring, mock, pytestCheckHook }:

buildPythonPackage rec {
  pname = "plyer";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kivy";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-7Icb2MVj5Uit86lRHxal6b7y9gIJ3UT2HNqpA9DYWVE=";
  };

  postPatch = ''
    rm -r examples
    # remove all the wifi stuff. Depends on a python wifi module that has not been updated since 2016
    find -iname "wifi*" -exec rm {} \;
    substituteInPlace plyer/__init__.py \
      --replace "wifi = Proxy('wifi', facades.Wifi)" "" \
      --replace "'wifi', " ""
    substituteInPlace plyer/facades/__init__.py \
      --replace "from plyer.facades.wifi import Wifi" ""
  '';

  propagatedBuildInputs = [ keyring ];

  nativeCheckInputs = [ mock pytestCheckHook ];

  pytestFlagsArray = [ "plyer/tests" ];
  disabledTests = [
    # assumes dbus is not installed, it fails and is not very robust.
    "test_notification_notifysend"
    # fails during nix-build, but I am not able to explain why.
    # The test and the API under test do work outside the nix build.
    "test_uniqueid"
  ];
  preCheck = ''
    HOME=$(mktemp -d)
    mkdir -p $HOME/.config/ $HOME/Pictures
  '';

  pythonImportsCheck = [ "plyer" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Plyer is a platform-independent api to use features commonly found on various platforms";
    homepage = "https://github.com/kivy/plyer";
    license = licenses.mit;
    maintainers = with maintainers; [ rski ];
  };
}
