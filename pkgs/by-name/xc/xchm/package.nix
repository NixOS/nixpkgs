{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxwidgets_3_2,
  chmlib,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xchm";
  version = "1.39";

  src = fetchFromGitHub {
    owner = "rzvncj";
    repo = "xCHM";
    rev = finalAttrs.version;
    sha256 = "sha256-u/7f3yGWvCjmYhd5fs5TcSccz8Wr+WFQlHqUqgriUc0=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    wxwidgets_3_2
    chmlib
  ];

  configureFlags = [ "--with-wx-prefix=${wxwidgets_3_2}" ];

  preConfigure = ''
    export LDFLAGS="$LDFLAGS $(${wxwidgets_3_2}/bin/wx-config --libs std,aui | sed -e s@-pthread@@)"
  '';

  meta = {
    description = "Viewer for Microsoft HTML Help files";
    homepage = "https://github.com/rzvncj/xCHM";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
    mainProgram = "xchm";
  };
})
