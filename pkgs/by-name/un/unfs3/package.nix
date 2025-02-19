{
  fetchFromGitHub,
  lib,
  stdenv,
  flex,
  bison,
  autoreconfHook,
  pkg-config,
  libtirpc,
}:

stdenv.mkDerivation rec {
  pname = "unfs3";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "unfs3";
    repo = pname;
    rev = "refs/tags/${pname}-${version}";
    hash = "sha256-5iAriIutBhwyZVS7AG2fnkrHOI7pNAKfYv062Cy0WXw=";
  };

  nativeBuildInputs = [
    flex
    bison
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libtirpc ];

  configureFlags = [ "--disable-shared" ];

  doCheck = false; # no test suite

  meta = {
    description = "User-space NFSv3 file system server";

    longDescription = ''
      UNFS3 is a user-space implementation of the NFSv3 server
      specification.  It provides a daemon for the MOUNT and NFS
      protocols, which are used by NFS clients for accessing files on the
      server.
    '';

    # The old http://unfs3.sourceforge.net/ has a <meta>
    # http-equiv="refresh" pointing here, so we can assume that
    # whoever controls the old URL approves of the "unfs3" github
    # account.
    homepage = "https://unfs3.github.io/";
    changelog = "https://raw.githubusercontent.com/unfs3/unfs3/unfs3-${version}/NEWS";
    mainProgram = "unfsd";

    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
