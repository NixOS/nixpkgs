{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
  version = "1.2.6";
  pname = "libnftnl";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.xz";
    hash = "sha256-zurqLNkhR9oZ8To1p/GkvCdn/4l+g45LR5z1S1nHd/Q=";
  };

  configureFlags = lib.optional (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17") "LDFLAGS=-Wl,--undefined-version";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  meta = with lib; {
    description = "Userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = "https://netfilter.org/projects/libnftnl/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ] ++ teams.helsinki-systems.members;
  };
}
