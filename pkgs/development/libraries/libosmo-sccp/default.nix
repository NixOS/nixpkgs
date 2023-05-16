{ lib, stdenv, fetchgit, autoreconfHook, pkg-config
, libosmocore, libosmo-netif, lksctp-tools
}:


stdenv.mkDerivation rec {
  pname = "libosmo-sccp";
  version = "1.7.0";

  src = fetchgit {
    url = "https://gitea.osmocom.org/osmocom/libosmo-sccp";
    rev = version;
    sha256 = "sha256-ScJZke9iNmFc9XXqtRjb24ZzKfa5EYws5PDNhcZFb7U=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    libosmo-netif
    lksctp-tools
  ];

  meta = with lib; {
    description = "Implementation of telecom signaling protocols and OsmoSTP";
    homepage = "https://osmocom.org/projects/osmo-stp/wiki";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.agpl3Only;
  };
}
