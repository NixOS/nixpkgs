{
  stdenv,
  lib,
  fetchFromGitHub,
  zlib,
  openssl,
  ncurses,
  libidn,
  pcre2,
  libssh,
  libmysqlclient,
  libpq,
  samba,
}:

stdenv.mkDerivation rec {
  pname = "thc-hydra";
  version = "9.7";

  src = fetchFromGitHub {
    owner = "vanhauser-thc";
    repo = "thc-hydra";
    rev = "v${version}";
    sha256 = "sha256-6YNHy9k/NJkZYj0TjciPMOXMq/McGQnmj7HWk6KbgI4=";
  };

  postPatch =
    let
      makeDirs =
        output: subDir:
        lib.concatStringsSep " " (map (path: lib.getOutput output path + "/" + subDir) buildInputs);
    in
    ''
      substituteInPlace configure \
        --replace-fail '$LIBDIRS' "${makeDirs "lib" "lib"}" \
        --replace-fail '$INCDIRS' "${makeDirs "dev" "include"}" \
        --replace-fail "/usr/include/math.h" "${lib.getDev stdenv.cc.libc}/include/math.h" \
        --replace-fail "libcurses.so" "libncurses.so" \
        --replace-fail "-lcurses" "-lncurses"
    '';

  buildInputs = [
    zlib
    openssl
    ncurses
    libidn
    pcre2
    libssh
    libmysqlclient
    libpq
    samba
  ];

  enableParallelBuilding = true;

  env.DATADIR = "/share/${pname}";

  meta = {
    description = "Very fast network logon cracker which support many different services";
    homepage = "https://github.com/vanhauser-thc/thc-hydra"; # https://www.thc.org/
    changelog = "https://github.com/vanhauser-thc/thc-hydra/raw/v${version}/CHANGES";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
