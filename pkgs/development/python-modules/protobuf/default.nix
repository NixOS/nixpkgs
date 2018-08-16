{ stdenv, python, buildPythonPackage
, protobuf, google_apputils, pyext, libcxx
, disabled, doCheck ? true }:

with stdenv.lib;

buildPythonPackage rec {
  inherit (protobuf) name src version;
  inherit disabled doCheck;

  NIX_CFLAGS_COMPILE =
    # work around python distutils compiling C++ with $CC
    optional stdenv.isDarwin "-I${libcxx}/include/c++/v1"
    ++ optional (versionOlder protobuf.version "2.7.0") "-std=c++98";

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

  preBuild = ''
    # Workaround for https://github.com/google/protobuf/issues/2895
    ${python}/bin/${python.executable} setup.py build
  '' + optionalString (versionAtLeast protobuf.version "2.6.0") ''
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
