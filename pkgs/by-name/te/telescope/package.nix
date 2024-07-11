{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, bison
, libevent
, libgrapheme
, libressl
, ncurses
, autoreconfHook
, buildPackages
, memstreamHook
}:

stdenv.mkDerivation rec {
  pname = "telescope";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    hash = "sha256-OAqXYmlehL9AjZ7V0U0h7RCm/hn77Sf0Wp6R/GRaGY8=";
  };

  postPatch = ''
    # Remove bundled libraries
    rm -r libgrapheme
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
  ];

  buildInputs = [
    libevent
    libgrapheme
    libressl
    ncurses
  ] ++ lib.optional stdenv.isDarwin memstreamHook;

  configureFlags = [
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
  ];

  meta = with lib; {
    description = "Telescope is a w3m-like browser for Gemini";
    homepage = "https://telescope.omarpolo.com/";
    license = licenses.isc;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.unix;
  };
}
