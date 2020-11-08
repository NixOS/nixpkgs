{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, gettext }:

stdenv.mkDerivation rec {
  pname = "libexif";
  version = "0.6.22";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${builtins.replaceStrings ["."] ["_"] version}-release";
    sha256 = "0mzndakdi816zcs13z7yzp7hj031p2dcyfq2p391r63d9z21jmy1";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-0198.patch";
      url = "https://github.com/libexif/libexif/commit/ce03ad7ef4e8aeefce79192bf5b6f69fae396f0c.patch";
      sha256 = "1040278g5dbq3vvlyk8cmzb7flpi9bfsp99268hw69i6ilwbdf2k";
    })
    (fetchpatch {
      name = "CVE-2020-0452.patch";
      url = "https://github.com/libexif/libexif/commit/9266d14b5ca4e29b970fa03272318e5f99386e06.patch";
      excludes = [ "NEWS" ];
      sha256 = "0k4z1gbbkli6wwyy9qm2qvn0h00qda6wqym61nmmbys7yc2zryj6";
    })
  ];

  nativeBuildInputs = [ autoreconfHook gettext ];

  meta = with stdenv.lib; {
    homepage = "https://libexif.github.io/";
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ erictapen ];
  };

}
