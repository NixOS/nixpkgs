{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, python3
, subunit
, dpdk
, mbedtls_2
, rdma-core
, libnl
, libmnl
, libpcap
, check
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "vpp";
  version = "23.10";

  src = fetchFromGitHub {
    owner = "FDio";
    repo = "vpp";
    rev = "v${version}";
    hash = "sha256-YcDMDHvKIL2tOD98hTcuyQrL5pk80olYKNWiN+BA49U=";
  };

  patches = [
    # Important fix part of 24.02 for the Linux Control Plane.
    (fetchpatch {
      name = "fix-looping-netlink-messages.patch";
      url = "https://gerrit.fd.io/r/changes/vpp~39622/revisions/9/patch?download";
      decode = "base64 -d";
      stripLen = 1;
      hash = "sha256-0ZDKJgXrmTzlVSSapdEoP27znKuWUrnjTXZZ4JrximA=";
    })
# Does not apply cleanly.
#    (fetchpatch {
#      name = "fix-optional-labels-for-prometheus.patch";
#      url = "https://gerrit.fd.io/r/changes/vpp~40199/revisions/4/patch?download";
#      decode = "base64 -d";
#      stripLen = 1;
#      hash = "sha256-exuR4DucNtER2t1ecsjuNxzmhfZkhx6ABeeXmf/qQ4U=";
#    })
  ];

  postPatch = ''
    patchShebangs scripts/
    substituteInPlace CMakeLists.txt \
      --replace "plugins tools/vppapigen tools/g2 tools/perftool cmake pkg" "plugins tools/vppapigen tools/g2 tools/perftool cmake"
  '';

  preConfigure = ''
    echo "${version}-nixos" > scripts/.version
    scripts/version
  '';

  postConfigure = ''
    patchShebangs ../tools/
    patchShebangs ../vpp-api/
  '';

  sourceRoot = "source/src";

  cmakeFlags = [ "-DVPP_PLATFORM=default" ];

  # A bunch of GCC13 warnings I suppose.
  env.NIX_CFLAGS_COMPILE = "-Wno-array-bounds -Wno-error";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
    subunit
    dpdk
    rdma-core
    mbedtls_2
    check
    libnl
    libmnl
    libpcap
    (python3.withPackages (ps: [ ps.ply ]))
  ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/FDio/vpp";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
    mainProgram = "vpp";
    platforms = platforms.all;
  };
}
