{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tvm";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-tvm";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-g8Z5MRM3KIgCjGxtU9JLEsFUjFxPKmc6OwY17C59cxg=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://tvm.apache.org/";
    description = "An End to End Deep Learning Compiler Stack for CPUs, GPUs and accelerators";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ adelbertc ];
  };
}
