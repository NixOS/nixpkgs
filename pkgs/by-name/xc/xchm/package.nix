{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxGTK32,
  chmlib,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation rec {
  pname = "xchm";
  version = "1.37";

  src = fetchFromGitHub {
    owner = "rzvncj";
    repo = "xCHM";
    rev = version;
    sha256 = "sha256-UMn8ds4nheuYSu0PesxdGoyxyn5AcKq9WByeRUxxx3k=";
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

  meta = with lib; {
    description = "Viewer for Microsoft HTML Help files";
    homepage = "https://github.com/rzvncj/xCHM";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
    mainProgram = "xchm";
  };
}
