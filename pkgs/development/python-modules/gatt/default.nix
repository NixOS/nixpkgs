{ lib
, buildPythonPackage
, fetchFromGitHub
, dbus-python
, pygobject3
}:

buildPythonPackage rec {
  pname = "gatt";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "getsenic";
    repo = "gatt-python";
<<<<<<< HEAD
    rev = version;
=======
    rev = "${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hash = "sha256-GMLqQ9ojQ649hbbJB+KiQoOhiTWweOgv6zaCDzhIB5A=";
  };

  propagatedBuildInputs = [
    dbus-python
    pygobject3
  ];

  pythonImportsCheck = [ "gatt" ];

  meta = with lib; {
    description = "Bluetooth (Generic Attribute Profile) GATT SDK for Python";
    homepage = "https://github.com/getsenic/gatt-python/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ tomfitzhenry ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
