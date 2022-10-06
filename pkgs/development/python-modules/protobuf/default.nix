{ buildPackages
, lib
, buildPythonPackage
, protobuf
, pyext
, isPyPy
}:

buildPythonPackage {
  inherit (protobuf) pname src version;
  disabled = isPyPy;

  prePatch = ''
    while [ ! -d python ]; do
      cd *
    done
    cd python
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
