{ stdenv, fetchurl, pkgconfig, pure, libffi }:

stdenv.mkDerivation rec {
  baseName = "ffi";
  version = "0.14";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "0331f48efaae40af21b23cf286fd7eac0ea0a249d08fd97bf23246929c0ea71a";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure libffi ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "Provides an interface to libffi which enables you to call C functions from Pure and vice versa";
    homepage = http://puredocs.bitbucket.org/pure-ffi.html;
    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
