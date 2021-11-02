{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, which
, gettext, libffi, libiconv, libtasn1
}:

stdenv.mkDerivation rec {
  pname = "p11-kit";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = pname;
    rev = version;
    sha256 = "sha256-jvUzOhMvbq05SxQ+kjKQHDDMzNwo4U6nFHu3JjygJHw=";
  };

  outputs = [ "out" "dev"];
  outputBin = "dev";

  # for cross platform builds of p11-kit, libtasn1 in nativeBuildInputs
  # provides the asn1Parser binary on the hostPlatform needed for building.
  # at the same time, libtasn1 in buildInputs provides the libasn1 library
  # to link against for the target platform.
  # hence, libtasn1 is required in both native and build inputs.
  nativeBuildInputs = [ autoreconfHook pkg-config which libtasn1 ];
  buildInputs = [ gettext libffi libiconv libtasn1 ];

  autoreconfPhase = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-trust-paths=/etc/ssl/trust-source:/etc/ssl/certs/ca-certificates.crt"
  ];

  enableParallelBuilding = true;

  # Tests run in fakeroot for non-root users
  preCheck = ''
    if [ "$(id -u)" != "0" ]; then
      export FAKED_MODE=1
    fi
  '';

  doCheck = !stdenv.isDarwin;

  installFlags = [
    "exampledir=${placeholder "out"}/etc/pkcs11"
  ];

  meta = with lib; {
    description = "Library for loading and sharing PKCS#11 modules";
    longDescription = ''
      Provides a way to load and enumerate PKCS#11 modules.
      Provides a standard configuration setup for installing
      PKCS#11 modules in such a way that they're discoverable.
    '';
    homepage = "https://p11-glue.github.io/p11-glue/p11-kit.html";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
