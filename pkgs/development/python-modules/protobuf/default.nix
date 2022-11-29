{ buildPackages
, lib
, buildPythonPackage
, protobuf
, pyext
, isPyPy
}:

let
  versionMajor = lib.versions.major protobuf.version;
  versionMinor = lib.versions.minor protobuf.version;
  versionPatch = lib.versions.patch protobuf.version;
in
buildPythonPackage {
  inherit (protobuf) pname src;

  # protobuf 3.21 coresponds with its python library 4.21
  version =
    if lib.versionAtLeast protobuf.version "3.21"
    then "${toString (lib.toInt versionMajor + 1)}.${versionMinor}.${versionPatch}"
    else protobuf.version;

  disabled = isPyPy;

  sourceRoot = "source/python";

  prePatch = ''
    if [[ "$(<../version.json)" != *'"python": "'"$version"'"'* ]]; then
      echo "Python library version mismatch. Derivation version: $version, actual: $(<../version.json)"
      exit 1
    fi
  '';

  nativeBuildInputs = [ pyext ];

  buildInputs = [ protobuf ];

  propagatedNativeBuildInputs = [
    # For protoc of the same version.
    buildPackages."protobuf${lib.versions.major protobuf.version}_${lib.versions.minor protobuf.version}"
  ];

  setupPyGlobalFlags = "--cpp_implementation";

  pythonImportsCheck = [
    "google.protobuf"
    "google.protobuf.internal._api_implementation" # Verify that --cpp_implementation worked
  ];

  passthru = {
    inherit protobuf;
  };

  meta = with lib; {
    description = "Protocol Buffers are Google's data interchange format";
    homepage = "https://developers.google.com/protocol-buffers/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
