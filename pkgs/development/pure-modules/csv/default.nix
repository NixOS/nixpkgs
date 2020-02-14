{ stdenv, fetchurl, pkgconfig, pure }:

stdenv.mkDerivation rec {
  baseName = "csv";
  version = "1.6";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "fe7c4edebe8208c54d5792a9eefaeb28c4a58b9094d161a6dda8126f0823ab3c";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "Comma Separated Value Interface for the Pure Programming Language";
    homepage = http://puredocs.bitbucket.org/pure-csv.html;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
