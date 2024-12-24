{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  zlib,
  openssl,
  libarchive,
}:

stdenv.mkDerivation rec {
  pname = "xbps";
  version = "0.59.2";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "xbps";
    rev = version;
    hash = "sha256-3+LzFLDZ1zfRPBETMlpEn66zsfHRHQLlgeZPdMtmA14=";
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [
    zlib
    openssl
    libarchive
  ];

  patches = [
    ./cert-paths.patch
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result -Wno-error=deprecated-declarations";

  postPatch = ''
    # _BSD_SOURCE causes cpp warning
    # https://github.com/void-linux/xbps/issues/576
    substituteInPlace bin/xbps-fbulk/main.c lib/util.c lib/external/dewey.c lib/external/fexec.c \
      --replace 'define _BSD_SOURCE' 'define _DEFAULT_SOURCE' \
      --replace '# define _BSD_SOURCE' '#define _DEFAULT_SOURCE'

    # fix unprefixed ranlib (needed on cross)
    substituteInPlace lib/Makefile \
      --replace 'SILENT}ranlib ' 'SILENT}$(RANLIB) '

    # Don't try to install keys to /var/db/xbps, put in $out/share for now
    substituteInPlace data/Makefile \
      --replace '$(DESTDIR)/$(DBDIR)' '$(DESTDIR)/$(SHAREDIR)'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/void-linux/xbps";
    description = "X Binary Package System";
    platforms = platforms.linux; # known to not work on Darwin, at least
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
