{ lib, stdenv, fetchgit, autoreconfHook, pkg-config
, libosmocore, ortp, bctoolbox
}:

stdenv.mkDerivation rec {
  pname = "libosmo-abis";
  version = "1.4.0";

  src = fetchgit {
    url = "https://gitea.osmocom.org/osmocom/libosmo-abis";
    rev = version;
    sha256 = "sha256-RKJis0Ur3Y0LximNQl+hm6GENg8t2E1S++2c+63D2pQ=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  configureFlags = [ "--disable-dahdi" ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    ortp
    bctoolbox
  ];

  meta = with lib; {
    description = "GSM A-bis interface library";
    homepage = "https://osmocom.org/projects/libosmo-abis";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.agpl3Only;
  };
}
