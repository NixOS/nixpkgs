{ fetchgit, stdenv, lib, autoreconfHook, pkg-config, curl, expat, libmicrohttpd }:

stdenv.mkDerivation rec {
  pname = "libnpupnp";
  version = "2.1.2";

  src = fetchgit {
    url = "https://framagit.org/medoc92/npupnp.git";
    rev = "libnpupnp-v${version}";
    sha256 = "sha256-EEUCMxVCcgJNxWrHMqJ9R4ap/hlBL3tzAPXR7OrqBRw=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config curl expat libmicrohttpd ];

  #hardeningDisable = [ "fortify" ];

  meta = {
    description = "A C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp";

    longDescription = ''
      npupnp (new pupnp or not pupnp ?) is an UPnP library derived from the
      venerable pupnp (https://github.com/pupnp/pupnp), based on its 1.6.x
      branch (around 1.6.25).

      The Linux SDK for UPnP Devices (libupnp) provides developers
      with an API and open source code for building control points,
      devices, and bridges that are compliant with Version 1.0 of the
      UPnP Device Architecture Specification.
    '';

    license = "BSD-style";

    homepage = "https://framagit.org/medoc92/npupnp";
    platforms = lib.platforms.unix;
  };
}
