{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, protobufc
, protobuf
, cmake
, pytestrunner
, numpy
, typing
, typing-extensions
}:

buildPythonPackage rec {
  pname = "onnx";
  version = "1.2.2";

  # FIXME: Disable mypy suport due to build failures, see
  # https://github.com/NixOS/nixpkgs/pull/42807 for details
  CMAKE_ARGS="-DONNX_GEN_PB_TYPE_STUBS=Off";

  # FIXME: mypy and typing-extensions are intended to produce typing stubs.
  # Sadly, they dont go saying `Failed to generate mypy stubs: No module
  # named 'google.protobuf.compiler'`
  nativeBuildInputs = [ cmake protobufc pytestrunner ];
  propagatedBuildInputs = [ protobuf numpy typing typing-extensions ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kyj0ivxdbi86mkq78wwm8hbgvl24xn5w8r1fvb5grd8md36xl4g";
  };

  # FIXME: Workaround 'ERROR: file not found: onnx/examples'. Maybe one shold
  # try `fetchgit` instead of `fetchPypi`.
  doCheck = false;

  meta = {
    homepage = https://onnx.ai;
    description = "Open Neural Network Exchange";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ smironov ];
  };
}
