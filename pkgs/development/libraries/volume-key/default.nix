{ stdenv, fetchgit, fetchpatch, autoreconfHook, pkgconfig, gettext, python2
, swig, glib, utillinux, cryptsetup, nss, gpgme
}:

let
  version = "0.3.9";
in stdenv.mkDerivation rec {
  name = "volume_key-${version}";

  src = fetchgit {
    url = https://pagure.io/volume_key.git;
    rev = name;
    sha256 = "1773432gd9vhwj7lfmk6bwybm7lkc3rmblp865gm0flkqlkhr537";
  };

  outputs = [ "out" "man" "dev" ];
  outputBin = "dev";

  nativeBuildInputs = [ autoreconfHook pkgconfig gettext python2 swig ];

  buildInputs = [ glib cryptsetup nss utillinux gpgme ];

  patches = [
    # Do not include config.h in libvolume_key.h
    (fetchpatch {
      url = https://pagure.io/volume_key/c/8f8698aba19b501f01285e9eec5c18231fc6bcea.patch;
      sha256 = "0jcrakjgzjb8zmzlyv40fiwkzr2j0ni8ksgg6633x9zkf4q5ay9n";
    })
    # Fix compatibility with cryptsetup 2.0
    (fetchpatch {
      url = https://pagure.io/volume_key/c/ecef526a51c5a276681472fd6df239570c9ce518.patch;
      sha256 = "1cadn7hd2q05yjlvvnnwy6vdwxs8wvm48ab7jqrpby7l7jz4zmx2";
    })
    # Use pkg-config for locating Python.h
    # https://pagure.io/volume_key/pull-request/12
    (fetchpatch {
      url = https://pagure.io/fork/cathay4t/volume_key/c/028106f408206dcabece6ee7cbe09ef3bb327988.patch;
      sha256 = "1c82wilr5kxjq04740xcd9pmxzrk82g7mn2sicbz0g7x5c1qgs0b";
    })
  ];

  meta = with stdenv.lib; {
    description = "A library for manipulating storage volume encryption keys and storing them separately from volumes to handle forgotten passphrases, and the associated command-line tool";
    homepage = https://pagure.io/volume_key/;
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
