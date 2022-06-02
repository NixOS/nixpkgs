{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, substituteAll
, pkgs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "libevdev";
  version = "0.10";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9LM2Ftr6qmQYysCxso+XJSthwJdOU01J+yL8ZWbtwRM=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      libevdev = lib.getLib pkgs.libevdev;
    })
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python wrapper around the libevdev C library";
    homepage = "https://gitlab.freedesktop.org/libevdev/python-libevdev";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
