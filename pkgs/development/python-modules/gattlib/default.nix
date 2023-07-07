{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll

# build
, pkg-config
, glibc
, python

# runtime
, bluez
, boost
, glib

}:

let
  pname = "gattlib";
  version = "unstable-2021-06-16";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";


  src = fetchFromGitHub {
    owner = "oscaracena";
    repo = "pygattlib";
    rev = "7bdb229124fe7d9f4a2cc090277b0fdef82e2a56";
    hash = "sha256-PS5DIH1JuH2HweyebLLM+UNFGY/XsjKIrsD9x7g7yMI=";
  };

  patches = [
    (substituteAll {
      src = ./setup.patch;
      boost_version = let
        pythonVersion = with lib.versions; "${major python.version}${minor python.version}";
      in
        "boost_python${pythonVersion}";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    glibc
  ];

  buildInputs = [
    bluez
    boost
    glib
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "gattlib"
  ];

  meta = with lib; {
    description = "Python library to use the GATT Protocol for Bluetooth LE devices";
    homepage = "https://github.com/oscaracena/pygattlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
