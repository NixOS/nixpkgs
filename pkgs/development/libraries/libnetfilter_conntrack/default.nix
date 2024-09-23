{ lib, stdenv, fetchurl, fetchpatch, pkg-config, libnfnetlink, libmnl }:

stdenv.mkDerivation rec {
  pname = "libnetfilter_conntrack";
  version = "1.0.9";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_conntrack/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-Z72d9J/jTouCFE9t+5OzIPOEqOpZcn6S/40YtfS1eag=";
  };

  patches = [
    # Fix Musl build.
    (fetchpatch {
      url = "https://git.netfilter.org/libnetfilter_conntrack/patch/?id=21ee35dde73aec5eba35290587d479218c6dd824";
      sha256 = "00rp82jrx5ygcw8la3c7bv7sigw9qzbn956dk71qjx981a2g2kqk";
    })
  ];

  hardeningDisable = [ "trivialautovarinit" ];

  buildInputs = [ libmnl ];
  propagatedBuildInputs = [ libnfnetlink ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Userspace library providing an API to the in-kernel connection tracking state table";
    longDescription = ''
      libnetfilter_conntrack is a userspace library providing a programming interface (API) to the
      in-kernel connection tracking state table. The library libnetfilter_conntrack has been
      previously known as libnfnetlink_conntrack and libctnetlink. This library is currently used
      by conntrack-tools among many other applications
    '';
    homepage = "https://netfilter.org/projects/libnetfilter_conntrack/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
