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
  withGUI ? false,
  makeWrapper,
  pkg-config,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "thc-hydra";
  version = "9.6";

  src = fetchFromGitHub {
    owner = "vanhauser-thc";
    repo = "thc-hydra";
    rev = "v${version}";
    sha256 = "sha256-DS3Fh4a6OtqZRHubgJewB7qnJXm10sYv85R6o/NePoU=";
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

  nativeBuildInputs = lib.optionals withGUI [
    pkg-config
    makeWrapper
  ];

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
  ]
  ++ lib.optional withGUI gtk2;

  enableParallelBuilding = true;

  DATADIR = "/share/${pname}";

  postInstall = lib.optionalString withGUI ''
    wrapProgram $out/bin/xhydra \
      --add-flags --hydra-path --add-flags "$out/bin/hydra"
  '';

  meta = {
    description = "Very fast network logon cracker which support many different services";
    homepage = "https://github.com/vanhauser-thc/thc-hydra"; # https://www.thc.org/
    changelog = "https://github.com/vanhauser-thc/thc-hydra/raw/v${version}/CHANGES";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ offline ];
    platforms = lib.platforms.unix;
  };
}
