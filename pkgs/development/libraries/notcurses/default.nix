{ stdenv, cmake, pkg-config, pandoc, libunistring, ncurses, ffmpeg,
  fetchFromGitHub, lib,
  multimediaSupport ? true
}:
let
  version = "2.1.0";
in
stdenv.mkDerivation {
  pname = "notcurses";
  inherit version;

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkg-config pandoc ];

  buildInputs = [ libunistring ncurses ]
    ++ lib.optional multimediaSupport ffmpeg;

  cmakeFlags =
    [ "-DUSE_QRCODEGEN=OFF" ]
    ++ lib.optional (!multimediaSupport) "-DUSE_MULTIMEDIA=none";

  src = fetchFromGitHub {
    owner  = "dankamongmen";
    repo   = "notcurses";
    rev    = "v${version}";
    sha256 = "0jvngg40c1sqf85kqy6ya0vflpxsj7j4g6cw609992rifaghxiny";
  };

  meta = {
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

    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jb55 ];
  };
}
