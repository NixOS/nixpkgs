{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gdk-pixbuf,
  gtk2,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "trayer";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "sargon";
    repo = "trayer-srg";
    rev = "${pname}-${version}";
    sha256 = "1mvhwaqa9bng9wh3jg3b7y8gl7nprbydmhg963xg0r076jyzv0cg";
  };

  postPatch = ''
    patchShebangs configure
  '';

  patches = [
    # Adding missing arg in function decleration
    (fetchpatch {
      name = "fix_function_dec.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/x11-misc/trayer-srg/files/trayer-srg-1.1.8-fix-define.patch?id=94ae89d1b044c24138d5c8903df68e9654a5462f";
      hash = "sha256-LighVaBDePheBO+dWG6JHhm/Y6sxdtvTrBar8VrPRH4=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gdk-pixbuf
    gtk2
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/sargon/trayer-srg";
    license = lib.licenses.mit;
    description = "Lightweight GTK2-based systray for UNIX desktop";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "trayer";
  };
}
