{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.9.5";
  pname = "tayga";

  src = fetchFromGitHub {
    owner = "apalrd";
    repo = "tayga";
    tag = finalAttrs.version;
    hash = "sha256-xOm4fetFq2UGuhOojrT8WOcX78c6MLTMVbDv+O62x2E=";
  };

  makeFlags = [ "CC=${lib.getExe stdenv.cc}" ];

  env = lib.optionalAttrs stdenv.hostPlatform.is32bit {
    NIX_CFLAGS_COMPILE = "-D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64";
  };

  preBuild = ''
    echo "#define TAYGA_VERSION \"${finalAttrs.version}\"" > version.h
  '';

  installPhase = ''
    install -Dm755 tayga $out/bin/tayga
    install -D tayga.conf.5 $out/share/man/man5/tayga.conf.5
    install -D tayga.8 $out/share/man/man8/tayga.8
    cp -R docs $out/share/
    cp tayga.conf.example $out/share/docs/
  '';

  passthru.tests.tayga = nixosTests.tayga;

  meta = with lib; {
    description = "Userland stateless NAT64 daemon";
    longDescription = ''
      TAYGA is an out-of-kernel stateless NAT64 implementation
      for Linux that uses the TUN driver to exchange IPv4 and
      IPv6 packets with the kernel.
      It is intended to provide production-quality NAT64 service
      for networks where dedicated NAT64 hardware would be overkill.
    '';
    homepage = "https://github.com/apalrd/tayga";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
    mainProgram = "tayga";
  };
})
