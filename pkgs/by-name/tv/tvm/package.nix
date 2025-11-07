{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "tvm";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-tvm";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-/5IpOraFTgg6sQ1TLHoepq/C8VHKg5BXKrNMBSyYajA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://tvm.apache.org/";
    description = "End to End Deep Learning Compiler Stack for CPUs, GPUs and accelerators";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ adelbertc ];
  };
}
