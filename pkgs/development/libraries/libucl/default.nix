{ stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, curl
, lua
, openssl
, features ? {
    urls = false;
    # Upstream enables regex by default
    regex = true;
    # Signature support is broken with openssl 1.1.1: https://github.com/vstakhov/libucl/issues/203
    signatures = false;
    lua = false;
    utils = false;
  }
}:

let
  featureDeps = {
    urls = [ curl ];
    signatures = [ openssl ];
    lua = [ lua ];
  };
in
stdenv.mkDerivation rec {
  pname = "libucl";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = pname;
    rev = version;
    sha256 = "1h52ldxankyhbbm1qbqz1f2q0j03c1b4mig7343bs3mc6fpm18gf";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = with stdenv.lib;
    concatLists (
      mapAttrsToList (feat: enabled:
        optionals enabled (featureDeps."${feat}" or [])
      ) features
    );

  enableParallelBuilding = true;

  configureFlags = with stdenv.lib;
    mapAttrsToList (feat: enabled: strings.enableFeature enabled feat) features;

  meta = with stdenv.lib; {
    description = "Universal configuration library parser";
    homepage = "https://github.com/vstakhov/libucl";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jpotier ];
  };
}
