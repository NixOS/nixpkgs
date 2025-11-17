{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "target-isns";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "target-isns";
    rev = "v${version}";
    sha256 = "1b6jjalvvkkjyjbg1pcgk8vmvc6xzzksyjnh2pfi45bbpya4zxim";
  };

  patches = [
    # fix absolute paths
    ./install_prefix_path.patch

    # fix gcc 10 compiler warning, remove with next update
    (fetchpatch {
      url = "https://github.com/open-iscsi/target-isns/commit/3d0c47dd89bcf83d828bcc22ecaaa5f58d78b58e.patch";
      sha256 = "1x2bkc1ff15621svhpq1r11m0q4ajv0j4fng6hm7wkkbr2s6d1vx";
    })

    (fetchpatch {
      name = "minimal-cmake-version.patch";
      url = "https://github.com/open-iscsi/target-isns/commit/e209821423f936d1cc9b946fb8f7a8979b8e751b.patch?full_index=1";
      hash = "sha256-86nl8wTiI9WSZ+Hhw/a9VtgS8OLqoFwiot5iU5IK0f8=";
    })
  ];

  cmakeFlags = [ "-DSUPPORT_SYSTEMD=ON" ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "iSNS client for the Linux LIO iSCSI target";
    mainProgram = "target-isns";
    homepage = "https://github.com/open-iscsi/target-isns";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
