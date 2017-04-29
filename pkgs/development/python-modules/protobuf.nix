{ stdenv, python, buildPythonPackage
, protobuf, google_apputils, pyext
, disabled, doCheck ? true }:

with stdenv.lib;

buildPythonPackage rec {
  inherit (protobuf) name src;
  inherit disabled doCheck;

  propagatedBuildInputs = [ protobuf google_apputils ];
  buildInputs = [ google_apputils pyext ];

  prePatch = ''
    while [ ! -d python ]; do
      cd *
    done
    cd python
  '';

  preConfigure = optionalString (versionAtLeast protobuf.version "2.6.0") ''
    export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
    export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=2
  '';

  preBuild = optionalString (versionAtLeast protobuf.version "2.6.0") ''
    ${python}/bin/${python.executable} setup.py build_ext --cpp_implementation
  '';

  installFlags = optional (versionAtLeast protobuf.version "2.6.0")
    "--install-option='--cpp_implementation'";

  # the _message.so isn't installed, so we'll do that manually.
  # if someone can figure out a less hacky way to get the _message.so to
  # install, please do replace this.
  postInstall = optionalString (versionAtLeast protobuf.version "2.6.0") ''
    cp -v $(find build -name "_message*") $out/${python.sitePackages}/google/protobuf/pyext
  '';

  meta = {
    description = "Protocol Buffers are Google's data interchange format";
    homepage = https://developers.google.com/protocol-buffers/;
  };

  passthru.protobuf = protobuf;
}
