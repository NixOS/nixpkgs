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
  version = "0.10";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    hash = "sha256-hkXXM/I7sNFomWamT0q1JH62arX1hFbt68Axcijadug=";
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
    homepage = "https://www.telescope-browser.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.unix;
  };
}
