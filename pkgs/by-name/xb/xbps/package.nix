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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "xbps";
  version = "0.60.6";
=======
stdenv.mkDerivation rec {
  pname = "xbps";
  version = "0.59.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "xbps";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-euV8oi1na+mfILnnUHK5S8Pi6+QuOUA8KhD0FHUqM70=";
=======
    rev = version;
    hash = "sha256-3+LzFLDZ1zfRPBETMlpEn66zsfHRHQLlgeZPdMtmA14=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  # Don't try to install keys to /var/db/xbps, put in $out/share for now
  postPatch = ''
    substituteInPlace data/Makefile \
      --replace-fail '$(DESTDIR)/$(DBDIR)' '$(DESTDIR)/$(SHAREDIR)'
=======
  postPatch = ''
    # _BSD_SOURCE causes cpp warning
    # https://github.com/void-linux/xbps/issues/576
    substituteInPlace bin/xbps-fbulk/main.c lib/util.c lib/external/dewey.c lib/external/fexec.c \
      --replace 'define _BSD_SOURCE' 'define _DEFAULT_SOURCE' \
      --replace '# define _BSD_SOURCE' '#define _DEFAULT_SOURCE'

    # fix calloc argument cause a build failure
    substituteInPlace bin/xbps-fbulk/main.c \
      --replace-fail 'calloc(sizeof(*depn), 1)' 'calloc(1UL, sizeof(*depn))'

    # fix unprefixed ranlib (needed on cross)
    substituteInPlace lib/Makefile \
      --replace 'SILENT}ranlib ' 'SILENT}$(RANLIB) '

    # Don't try to install keys to /var/db/xbps, put in $out/share for now
    substituteInPlace data/Makefile \
      --replace '$(DESTDIR)/$(DBDIR)' '$(DESTDIR)/$(SHAREDIR)'
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/void-linux/xbps";
    description = "X Binary Package System";
    platforms = lib.platforms.linux; # known to not work on Darwin, at least
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
=======
  meta = with lib; {
    homepage = "https://github.com/void-linux/xbps";
    description = "X Binary Package System";
    platforms = platforms.linux; # known to not work on Darwin, at least
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
