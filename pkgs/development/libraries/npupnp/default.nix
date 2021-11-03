{ fetchgit, stdenv, lib, autoreconfHook, pkg-config, curl, expat, libmicrohttpd, nix-update-script }:

stdenv.mkDerivation rec {
  pname = "libnpupnp";
  version = "4.1.5";

  src = fetchgit {
    url = "https://framagit.org/medoc92/npupnp.git";
    rev = "libnpupnp-v${version}";
    sha256 = "sha256-eMQ5auMLdZwk6UorXQaWE9JKBHytTApnetAB4gn76RQ=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config curl expat libmicrohttpd ];

  #hardeningDisable = [ "fortify" ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

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
