{ fetchFromGitHub, stdenv, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libupnp";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "mrjimenez";
    repo = "pupnp";
    rev = "release-${version}";
    sha256 = "1wp9sz2ld4g6ak9v59i3s5mbsraxsphi9k91vw9xgrbzfmg8w0a6";
  };
  outputs = [ "dev" "out" ];

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
