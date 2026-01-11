{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXft,
}:
stdenv.mkDerivation rec {
  pname = "xfractint";
  version = "20.04p16";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "https://www.fractint.net/ftp/current/linux/xfractint-${version}.tar.gz";
    sha256 = "1ba77jifxv8jql044mdydh4p4ms4w5vw3qrqmcfzlvqfxk7h2m2f";
  };

  buildInputs = [
    libX11
    libXft
  ];

  configurePhase = ''
    runHook preConfigure

    sed -e 's@/usr/bin/@@' -i Makefile

    runHook postConfigure
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "";
    # Code cannot be used in commercial programs
    # Looks like the definition hinges on the price, not license
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://www.fractint.net/";
    mainProgram = "xfractint";
  };
}
