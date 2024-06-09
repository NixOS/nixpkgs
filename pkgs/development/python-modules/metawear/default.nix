{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  gcc,
  cython,
  boost,
  bluez,
  nlohmann_json,
  pyserial,
  requests,
  warble,
}:

buildPythonPackage rec {
  pname = "metawear";
  version = "1.0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gNEI6P6GslNd1DzFwCFndVIfUvSTPYollGdqkZhQ4Y8=";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = [
    boost
    bluez
    nlohmann_json
  ];

  postPatch = ''
    # remove vendored nlohmann_json
    rm MetaWear-SDK-Cpp/src/metawear/dfu/cpp/json.hpp
    substituteInPlace MetaWear-SDK-Cpp/src/metawear/dfu/cpp/file_operations.cpp \
        --replace '#include "json.hpp"' '#include <nlohmann/json.hpp>'
  '';

  propagatedBuildInputs = [
    pyserial
    requests
    warble
  ];

  enableParallelBuilding = true;

  pythonImportsCheck = [
    "mbientlab"
    "mbientlab.metawear"
  ];

  meta = with lib; {
    description = "Python bindings for the MetaWear C++ SDK by MbientLab";
    homepage = "https://github.com/mbientlab/metawear-sdk-python";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ stepbrobd ];
    platforms = platforms.linux;
  };
}
