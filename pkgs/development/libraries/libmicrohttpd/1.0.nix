{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "1.0.11";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    hash = "sha256-8iegRLdWiORJtY3e3wWCJVzFYomf9p8XOo73ZDl0S04=";
  };

  meta = {
    changelog = "https://git.gnunet.org/gnunet/libmicrohttpd/file/ChangeLog.html";
  };
}
