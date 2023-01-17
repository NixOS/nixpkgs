{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, flex
}:

stdenv.mkDerivation rec {
  pname = "libconfuse";
  version = "3.3";

  src = fetchFromGitHub {
    sha256 = "1npfk5jv59kk4n8pkyx89fn9s6p8x3gbffs42jaw24frgxfgp8ca";
    rev = "v${version}";
    repo = "libconfuse";
    owner = "martinh";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-40320.patch";
      urls = [
        "https://sources.debian.org/data/main/libc/libconfuse/3.3-3/debian/patches/CVE-2022-40320.patch"
        # files on sources.debian.org can disappear
        "https://web.archive.org/web/20230107133212/https://sources.debian.org/data/main/libc/libconfuse/3.3-3/debian/patches/CVE-2022-40320.patch"
      ];
      sha256 = "sha256-ftfE9JFz4nyRSOb2xHb9BAtgWn5Yv2WLm4RegDLtiBw=";
    })
  ];

  postPatch = ''
    substituteInPlace tests/Makefile.am \
      --replace 'TESTS            += empty_string' "" \
      --replace 'TESTS            += print_filter' ""
  '';

  nativeBuildInputs = [ autoreconfHook flex ];

  # occasional failures involving `lexer.o`
  #enableParallelBuilding = true;

  # On darwin the tests depend on the installed libraries because of install_name.
  doInstallCheck = true;
  installCheckTarget = "check";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Small configuration file parser library for C";
    longDescription = ''
      libConfuse (previously libcfg) is a configuration file parser library
      written in C. It supports sections and (lists of) values, as well as
      some other features. It makes it very easy to add configuration file
      capability to a program using a simple API.

      The goal of libConfuse is not to be the configuration file parser library
      with a gazillion of features. Instead, it aims to be easy to use and
      quick to integrate with your code.
    '';
    license = licenses.isc;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
