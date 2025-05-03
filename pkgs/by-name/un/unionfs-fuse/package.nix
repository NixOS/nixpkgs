{
  nix-update-script,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fuse3,
  fuse,
}:

let
  fuseCustom = if stdenv.hostPlatform.isDarwin then fuse else fuse3;
in
stdenv.mkDerivation rec {
  pname = "unionfs-fuse";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "rpodgorny";
    repo = "unionfs-fuse";
    tag = "v${version}";
    hash = "sha256-1Fy3evatfEplgJjAVeXgdq1CkGgIi+iZjsO0WBHmmBM=";
  };

  patches = [
    # Prevent the unionfs daemon from being killed during
    # shutdown. See
    # https://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons/
    # for details.
    ./prevent-kill-on-shutdown.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace '/usr/local/include/osxfuse/fuse' '${lib.getDev fuseCustom}/include/fuse'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    fuseCustom
  ];

  # Put the unionfs mount helper in place as mount.unionfs-fuse. This makes it
  # possible to do:
  #   mount -t unionfs-fuse none /dest -o dirs=/source1=RW,/source2=RO
  #
  # This must be done in preConfigure because the build process removes
  # helper from the source directory during the build.
  preConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/sbin
    cp -a mount.unionfs $out/sbin/mount.unionfs-fuse
    substituteInPlace $out/sbin/mount.unionfs-fuse --replace mount.fuse ${fuse3}/sbin/mount.fuse3
    substituteInPlace $out/sbin/mount.unionfs-fuse --replace unionfs $out/bin/unionfs
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FUSE UnionFS implementation";
    homepage = "https://github.com/rpodgorny/unionfs-fuse";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.orivej ];
  };
}
