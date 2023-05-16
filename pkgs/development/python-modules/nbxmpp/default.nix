{ lib
, buildPythonPackage
<<<<<<< HEAD
=======
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitLab
, gobject-introspection
, idna
, libsoup_3
<<<<<<< HEAD
, packaging
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, precis-i18n
, pygobject3
, pyopenssl
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "nbxmpp";
<<<<<<< HEAD
  version = "4.3.2";
  format = "pyproject";
=======
  version = "4.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-vSLWaGYST1nut+0KAzURRKsr6XRtmYYTrkJiQEK3wa4=";
=======
    rev = version;
    hash = "sha256-PL+qNxeNubGSLqSci4uhRWtOIqs10p+A1VPfTwCLu84=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    # required for pythonImportsCheck otherwise libsoup cannot be found
    gobject-introspection
<<<<<<< HEAD
    setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    precis-i18n
  ];

  propagatedBuildInputs = [
    gobject-introspection
    idna
    libsoup_3
<<<<<<< HEAD
    packaging
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pygobject3
    pyopenssl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "nbxmpp"
  ];
=======
  pythonImportsCheck = [ "nbxmpp" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
