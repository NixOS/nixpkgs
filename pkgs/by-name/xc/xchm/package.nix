{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxGTK32,
  chmlib,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xchm";
  version = "1.38";

  src = fetchFromGitHub {
    owner = "rzvncj";
    repo = "xCHM";
    rev = finalAttrs.version;
    sha256 = "sha256-ZZ3cTUCeXbQSDF2ioMsmZYy6jLnQPw5C3KP+wYSvmVk=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    wxGTK32
    chmlib
  ];

  configureFlags = [ "--with-wx-prefix=${wxGTK32}" ];

  preConfigure = ''
    export LDFLAGS="$LDFLAGS $(${wxGTK32}/bin/wx-config --libs std,aui | sed -e s@-pthread@@)"
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
