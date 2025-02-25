{
  lib,
  stdenv,
  fetchurl,
  libcddb,
  pkg-config,
  ncurses,
  help2man,
  libiconv,
  Carbon,
  IOKit,
}:

stdenv.mkDerivation rec {
  pname = "libcdio";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/libcdio/libcdio/releases/download/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-b4+99NGJz2Pyp6FUnFFs1yDHsiLHqq28kkom50WkhTk=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    pkg-config
    help2man
  ];
  buildInputs =
    [
      libcddb
      libiconv
      ncurses
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Carbon
      IOKit
    ];

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Library for OS-independent CD-ROM and CD image access";
    longDescription = ''
      GNU libcdio is a library for OS-independent CD-ROM and
      CD image access.  It includes a library for working with
      ISO-9660 filesystems (libiso9660), as well as utility
      programs such as an audio CD player and an extractor.
    '';
    homepage = "https://www.gnu.org/software/libcdio/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
