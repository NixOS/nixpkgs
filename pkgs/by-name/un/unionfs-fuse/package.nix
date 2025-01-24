{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fuse,
  fuse3,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "unionfs-fuse";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "rpodgorny";
    repo = "unionfs-fuse";
    rev = "v${version}";
    sha256 = "sha256-yosS1x15E8Rtuvikkl0cr6VHTEWn/up+EzFybyiU0Lk=";
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
      --replace '/usr/local/include/osxfuse/fuse' '${lib.getDev fuse}/include/fuse'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    (lib.optionals stdenv.hostPlatform.isDarwin [
      fuse
    ])
    ++ (lib.optionals (!stdenv.hostPlatform.isDarwin) [
      fuse3
    ]);

  # Put the unionfs mount helper in place as mount.unionfs-fuse. This makes it
  # possible to do:
  #   mount -t unionfs-fuse none /dest -o dirs=/source1=RW,/source2=RO
  #
  # This must be done in preConfigure because the build process removes
  # helper from the source directory during the build.
  preConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/sbin
    cp -a mount.unionfs $out/sbin/mount.unionfs-fuse
    substituteInPlace $out/sbin/mount.unionfs-fuse --replace mount.fuse ${fuse3}/sbin/mount.fuse
    substituteInPlace $out/sbin/mount.unionfs-fuse --replace unionfs $out/bin/unionfs
  '';

  meta = with lib; {
    description = "FUSE UnionFS implementation";
    homepage = "https://github.com/rpodgorny/unionfs-fuse";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
