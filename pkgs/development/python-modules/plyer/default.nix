{ stdenv, lib, buildPythonPackage, fetchFromGitHub, fetchpatch, keyring, mock, pytestCheckHook }:

buildPythonPackage rec {
  pname = "plyer";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kivy";
    repo = pname;
    rev = version;
    sha256 = "15z1wpq6s69s76r6akzgg340bpc21l2r1j8270gp7i1rpnffcjwm";
  };

  patches = [
    # fix naming of the DOCUMENTS dir
    (fetchpatch {
      url = "https://github.com/rski/plyer/commit/99dabb2d62248fc3ea5705c2720abf71c9fc378b.patch";
      sha256 = "sha256-bbnw0TxH4FGTso5dopzquDCjrjZAy+6CJauqi/nfstA=";
    })
    # fix handling of the ~/.config/user-dirs.dir file
    (fetchpatch {
      url = "https://github.com/rski/plyer/commit/f803697a1fe4fb5e9c729ee6ef1997b8d64f3ccd.patch";
      sha256 = "sha256-akuh//P5puz2PwcBRXZQ4KoGk+fxi4jn2H3pTIT5M78=";
    })
  ];

  postPatch = ''
    rm -r examples
    # remove all the wifi stuff. Depends on a python wifi module that has not been updated since 2016
    find -iname "wifi*" -exec rm {} \;
    substituteInPlace plyer/__init__.py \
      --replace "wifi = Proxy('wifi', facades.Wifi)" "" \
      --replace "'wifi'" ""
    substituteInPlace plyer/facades/__init__.py \
      --replace "from plyer.facades.wifi import Wifi" ""
  '';

  propagatedBuildInputs = [ keyring ];

  checkInputs = [ mock pytestCheckHook ];

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
