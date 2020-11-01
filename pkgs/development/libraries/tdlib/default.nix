{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, stdenv }:

stdenv.mkDerivation rec {
  version = "unstable-2020-10-25";
  pname = "tdlib";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";

    # At version 1.6.0, this line was `rev = "v${version}". Version 1.6.9 (here called `unstable-2020-10-25`) uses an
    # explicit revision because 1.6.9 is not a tdlib GitHub release, and is therefore not hosted at
    # `https://github.com/tdlib/td/releases/tag/v1.6.9`. Please return to the `rev = "v${version}"` style on the next
    # version bump if you can, since that will allow `nixpkgs-update` to update the package automatically.
    rev = "32f2338bd199dd06a1b4b5f1ad14f2d4f2868f01";

    sha256 = "0wv03hlgzrsc04kcwnwz6dsmkdzvhb0i1wjs08gzivwxw06pkq4n";
  };

  buildInputs = [ gperf openssl readline zlib ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Cross-platform library for building Telegram clients";
    homepage = "https://core.telegram.org/tdlib/";
    license = [ licenses.boost ];
    platforms = platforms.unix;
    maintainers = [ maintainers.vyorkin ];
  };
}
