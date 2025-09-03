{
  stdenv,
  lib,
  fetchFromGitHub,
  libxslt,
  libaio,
  systemd,
  perl,
  docbook_xsl,
  coreutils,
  lsof,
  makeWrapper,
  sg3_utils,
}:

stdenv.mkDerivation rec {
  pname = "tgt";
  version = "1.0.95";

  src = fetchFromGitHub {
    owner = "fujita";
    repo = "tgt";
    rev = "v${version}";
    hash = "sha256-e7rI8/WQl1L78l2Nk9ajomRucPwsSqZ7fLSHSw11jeY=";
  };

  nativeBuildInputs = [
    libxslt
    docbook_xsl
    makeWrapper
  ];

  buildInputs = [
    systemd
    libaio
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SD_NOTIFY=1"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=maybe-uninitialized"
  ];

  hardeningDisable = lib.optionals stdenv.hostPlatform.isAarch64 [
    # error: 'read' writing 1 byte into a region of size 0 overflows the destination
    "fortify3"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  preConfigure = ''
    sed -i 's|/usr/bin/||' doc/Makefile
    sed -i 's|/usr/include/libaio.h|${libaio}/include/libaio.h|' usr/Makefile
    sed -i 's|/usr/include/sys/|${stdenv.cc.libc.dev}/include/sys/|' usr/Makefile
    sed -i 's|/usr/include/linux/|${stdenv.cc.libc.dev}/include/linux/|' usr/Makefile
  '';

  postInstall = ''
    substituteInPlace $out/sbin/tgt-admin \
      --replace "#!/usr/bin/perl" "#! ${perl.withPackages (p: [ p.ConfigGeneral ])}/bin/perl"
    wrapProgram $out/sbin/tgt-admin --prefix PATH : \
      ${lib.makeBinPath [
        lsof
        sg3_utils
        (placeholder "out")
      ]}

    install -D scripts/tgtd.service $out/etc/systemd/system/tgtd.service
    substituteInPlace $out/etc/systemd/system/tgtd.service \
      --replace "/usr/sbin/tgt" "$out/bin/tgt"

    # See https://bugzilla.redhat.com/show_bug.cgi?id=848942
    sed -i '/ExecStart=/a ExecStartPost=${coreutils}/bin/sleep 5' $out/etc/systemd/system/tgtd.service
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "iSCSI Target daemon with RDMA support";
    homepage = "https://github.com/fujita/tgt";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
