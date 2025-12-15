{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "wipe";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/wipe/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-RjkWNw+bNbs0QZwsCuPcTApHHbMuhZWvodFMAze2GqA=";
  };

  postPatch = ''
    # Do not strip binary during install
    substituteInPlace Makefile.in \
      --replace-fail '$(INSTALL_BIN) -s' '$(INSTALL_BIN)'
  '';

  nativeBuildInputs = [ autoreconfHook ];

  # fdatasync is undocumented on darwin with no header file which breaks the build.
  # use fsync instead.
  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "ac_cv_func_fdatasync=no";

  patches = [ ./fix-install.patch ];

  meta = {
    description = "Secure file wiping utility";
    homepage = "https://wipe.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "wipe";
  };
}
