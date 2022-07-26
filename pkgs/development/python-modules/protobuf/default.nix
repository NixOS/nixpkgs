{ buildPackages
, lib
, fetchpatch
, python
, buildPythonPackage
, isPy37
, protobuf
, google-apputils ? null
, six
, pyext
, isPy27
, disabled
, doCheck ? true
}:

buildPythonPackage {
  inherit (protobuf) pname src version;
  inherit disabled;
  doCheck = doCheck && !isPy27; # setuptools>=41.4 no longer collects correctly on python2

  propagatedBuildInputs = [ six ] ++ lib.optionals isPy27 [ google-apputils ];
  propagatedNativeBuildInputs = let
    protobufVersion = "${lib.versions.major protobuf.version}_${lib.versions.minor protobuf.version}";
  in [
    buildPackages."protobuf${protobufVersion}" # For protoc of the same version.
  ];

  nativeBuildInputs = [ pyext ] ++ lib.optionals isPy27 [ google-apputils ];
  buildInputs = [ protobuf ];

  patches = lib.optional (isPy37 && (lib.versionOlder protobuf.version "3.6.1.2"))
    # Python 3.7 compatibility (not needed for protobuf >= 3.6.1.2)
    (fetchpatch {
      url = "https://github.com/protocolbuffers/protobuf/commit/0a59054c30e4f0ba10f10acfc1d7f3814c63e1a7.patch";
      sha256 = "09hw22y3423v8bbmc9xm07znwdxfbya6rp78d4zqw6fisdvjkqf1";
      stripLen = 1;
    })
  ;

  prePatch = ''
    while [ ! -d python ]; do
      cd *
    done
    cd python
  '';

  setupPyGlobalFlags = lib.optional (lib.versionAtLeast protobuf.version "2.6.0")
    "--cpp_implementation";

  pythonImportsCheck = [
    "google.protobuf"
  ] ++ lib.optionals (lib.versionAtLeast protobuf.version "2.6.0") [
    "google.protobuf.internal._api_implementation" # Verify that --cpp_implementation worked
  ];

  meta = with lib; {
    description = "Protocol Buffers are Google's data interchange format";
    homepage = "https://developers.google.com/protocol-buffers/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };

  passthru.protobuf = protobuf;
}
