{ stdenv, fetchurl, fetchurl_gnome, which }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "gnome-common";
    major = "2"; minor = "34"; patchlevel = "0";
    sha256 = "1pz13mpp09q5s3bikm8ml92s1g0scihsm4iipqv1ql3mp6d4z73s";
  };

  propagatedBuildInputs = [ which ]; # autogen.sh which is using gnome_common tends to require which

  patches = [(fetchurl {
    url = "https://bug697543.bugzilla-attachments.gnome.org/attachment.cgi?id=240935";
    sha256 = "17abp7czfzirjm7qsn2czd03hdv9kbyhk3lkjxg2xsf5fky7z7jl";
  })];
}
