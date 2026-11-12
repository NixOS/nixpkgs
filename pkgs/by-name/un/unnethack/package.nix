{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linux,
  ncurses,
  flex,
  bison,
  lua5_5,
}:

stdenv.mkDerivation {
  pname = "unnethack";
  version = "6.0.16";

  src = fetchFromGitHub {
    owner = "UnNetHack";
    repo = "UnNetHack";
    # releases are not tagged
    rev = "7618459ee32b62004efb492ab7ac1b47c6852a80";
    hash = "sha256-MZdwdjP9J+ZGz44eiMdAdMcBW9RW1HWiiZQ1x4dGyPE=";
  };

  patches = [
    # util-linux does not contains "col" binary on Darwin. Only needed for documentation build.
    # https://github.com/util-linux/util-linux/commit/8886d84e25a457702b45194d69a47313f76dc6bc
    ./disable-col-check.patch
  ];

  buildInputs = [
    ncurses
    lua5_5
  ];

  nativeBuildInputs = [
    util-linux
    flex
    bison
  ];

  configureFlags = [
    "--enable-curses-graphics"
    "--disable-tty-graphics"
    "--with-owner=no"
    "--with-group=no"
    "--with-gamesdir=/tmp/unnethack"
  ];

  makeFlags = [ "GAMEPERM=744" ];

  enableParallelBuilding = true;

  postInstall = ''
    cp -r /tmp/unnethack $out/share/unnethack/profile
    mv $out/bin/unnethack $out/bin/.wrapped_unnethack
    cat <<EOF >$out/bin/unnethack
      #! ${stdenv.shell} -e
      if [ ! -d ~/.unnethack ]; then
        mkdir -p ~/.unnethack
        cp -r $out/share/unnethack/profile/* ~/.unnethack
        chmod -R +w ~/.unnethack
      fi

      ln -s ~/.unnethack /tmp/unnethack

      cleanup() {
        rm -rf /tmp/unnethack
      }
      trap cleanup EXIT

      $out/bin/.wrapped_unnethack
    EOF
    chmod +x $out/bin/unnethack
  '';

  meta = {
    description = "Fork of NetHack";
    mainProgram = "unnethack";
    homepage = "https://unnethack.wordpress.com/";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-30
      publicDomain
    ];
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
