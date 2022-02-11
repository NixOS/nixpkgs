{ lib, stdenv, fetchurl, pkg-config, pure }:

stdenv.mkDerivation rec {
  pname = "pure-csv";
  version = "1.6";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-csv-${version}.tar.gz";
    sha256 = "fe7c4edebe8208c54d5792a9eefaeb28c4a58b9094d161a6dda8126f0823ab3c";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "Comma Separated Value Interface for the Pure Programming Language";
    homepage = "http://puredocs.bitbucket.org/pure-csv.html";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
