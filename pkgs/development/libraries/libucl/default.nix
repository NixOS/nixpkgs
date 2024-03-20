{ lib, stdenv
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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = pname;
    rev = version;
    sha256 = "sha256-udgsgo6bT7WnUYnAzqHxOtdDg6av3XplptS8H5ukxjo=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = with lib;
    concatLists (
      mapAttrsToList (feat: enabled:
        optionals enabled (featureDeps."${feat}" or [])
      ) features
    );

  enableParallelBuilding = true;

  configureFlags = with lib;
    mapAttrsToList (feat: enabled: strings.enableFeature enabled feat) features;

  meta = with lib; {
    description = "Universal configuration library parser";
    homepage = "https://github.com/vstakhov/libucl";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jpotier ];
  };
}
