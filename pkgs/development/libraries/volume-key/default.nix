{ stdenv, fetchgit, fetchpatch, autoreconfHook, pkgconfig, gettext, python2
, swig, glib, utillinux, cryptsetup, nss, gpgme
}:

let
  version = "0.3.10";
in stdenv.mkDerivation rec {
  name = "volume_key-${version}";

  src = fetchgit {
    url = https://pagure.io/volume_key.git;
    rev = "ece1ce305234da454e330905c615ec474d9781c5";
    sha256 = "16qdi5s6ycsh0iyc362gly7ggrwamky8i0zgbd4ajp3ymk9vqdva";
  };

  outputs = [ "out" "man" "dev" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig gettext python2 swig ];

  buildInputs = [ glib cryptsetup nss utillinux gpgme ];

  patches = [
    # Use pkg-config for locating Python.h
    # https://pagure.io/volume_key/pull-request/12
    (fetchpatch {
      url = https://pagure.io/fork/cathay4t/volume_key/c/8eda66d3b734ea335e37cf9d7d173b9e8ebe2fd9.patch;
      sha256 = "01lr1zijk0imkk681zynm4w5ad3y6c9vdrmrzaib7w7ima75iczr";
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
