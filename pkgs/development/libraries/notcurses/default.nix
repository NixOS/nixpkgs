{ stdenv
, cmake
, pkg-config
, pandoc
, libunistring
, ncurses
, zlib
, ffmpeg
, fetchFromGitHub
, lib
, multimediaSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "notcurses";
  version = "2.4.8";

  src = fetchFromGitHub {
    owner = "dankamongmen";
    repo = "notcurses";
    rev = "v${version}";
    sha256 = "sha256-mVSToryo7+zW1mow8eJT8GrXYlGe/BeSheJtJDKAgzo=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkg-config pandoc ];

  buildInputs = [ libunistring ncurses zlib ]
    ++ lib.optional multimediaSupport ffmpeg;

  cmakeFlags = [ "-DUSE_QRCODEGEN=OFF" ]
    ++ lib.optional (!multimediaSupport) "-DUSE_MULTIMEDIA=none";

  meta = with lib; {
    description = "blingful TUIs and character graphics";
    longDescription = ''
      A library facilitating complex TUIs on modern terminal emulators,
      supporting vivid colors, multimedia, and Unicode to the maximum degree
      possible. Things can be done with Notcurses that simply can't be done
      with NCURSES.

      It is not a source-compatible X/Open Curses implementation, nor a
      replacement for NCURSES on existing systems.
    '';
    homepage = "https://github.com/dankamongmen/notcurses";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ jb55 ];
  };
}
