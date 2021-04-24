{ fetchFromGitHub, stdenv, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libupnp";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "mrjimenez";
    repo = "pupnp";
    rev = "release-${version}";
    sha256 = "17jhbzx8khz5vbl0lhcipjzgg897p1k2lp5wcc3hiddcfyh05pdj";
  };
  outputs = [ "dev" "out" ];

  patches = [
    ./CVE-2020-13848.patch
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  hardeningDisable = [ "fortify" ];

  meta = {
    description = "libupnp, an open source UPnP development kit for Linux";

    longDescription = ''
      The Linux SDK for UPnP Devices (libupnp) provides developers
      with an API and open source code for building control points,
      devices, and bridges that are compliant with Version 1.0 of the
      UPnP Device Architecture Specification.
    '';

    license = "BSD-style";

    homepage = "http://pupnp.sourceforge.net/";
    platforms = stdenv.lib.platforms.unix;
  };
}
