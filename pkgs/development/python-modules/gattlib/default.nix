{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  substituteAll,

  # build
  pkg-config,
  glibc,
  python,

  # runtime
  bluez,
  boost,
  glib,

}:

buildPythonPackage rec {
  pname = "gattlib";
  version = "20210616";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "oscaracena";
    repo = "pygattlib";
    rev = "v.${version}";
    hash = "sha256-n3D9CWKvgw4FYmbvsfhaHN963HARBG0p4CcZBC8Gkb0=";
  };

  patches = [
    (substituteAll {
      src = ./setup.patch;
      boost_version =
        let
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

  pythonImportsCheck = [ "gattlib" ];

  meta = with lib; {
    description = "Python library to use the GATT Protocol for Bluetooth LE devices";
    homepage = "https://github.com/oscaracena/pygattlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
