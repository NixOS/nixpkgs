{ fetchFromGitHub, stdenv, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libupnp-${version}";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "mrjimenez";
    repo = "pupnp";
    rev = "release-${version}";
    sha256 = "1daml02z4rs9cxls95p2v24jvwcsp43a0gqv06s84ay5yn6r47wx";
  };
  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook ];

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

    homepage = http://pupnp.sourceforge.net/;
    platforms = stdenv.lib.platforms.unix;
  };
}
