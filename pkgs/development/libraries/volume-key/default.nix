{ stdenv, fetchgit, autoreconfHook, pkgconfig, gettext, python3
, ncurses, swig, glib, utillinux, cryptsetup, nss, gpgme
, autoconf, automake, libtool
, buildPackages
}:

let
  version = "0.3.11";
in stdenv.mkDerivation {
  pname = "volume_key";
  inherit version;

  src = fetchgit {
    url = https://pagure.io/volume_key.git;
    rev = "volume_key-${version}";
    sha256 = "1sqdbcih1c39bjiv4mm1m7acc3lfh2i2hf2r9i7rk8adfzq8awma";
  };

  outputs = [ "out" "man" "dev" "py" ];

  nativeBuildInputs = [ autoconf automake libtool pkgconfig gettext swig ];

  buildInputs = [ autoreconfHook glib cryptsetup nss utillinux gpgme ncurses ];

  configureFlags = [
    "--with-gpgme-prefix=${gpgme.dev}"
  ];

  preConfigure = ''
    export PYTHON="${buildPackages.python3}/bin/python"
    export PYTHON3_CONFIG="${python3}/bin/python3-config"
  '';

  makeFlags = [
    "pyexecdir=$(py)/${python3.sitePackages}"
    "pythondir=$(py)/${python3.sitePackages}"
  ];

  doCheck = false; # fails 1 out of 1 tests, needs `certutil`

  meta = with stdenv.lib; {
    description = "A library for manipulating storage volume encryption keys and storing them separately from volumes to handle forgotten passphrases, and the associated command-line tool";
    homepage = https://pagure.io/volume_key/;
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
