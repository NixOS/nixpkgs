{ lib, stdenv, fetchurl, pkg-config, pure, libffi }:

stdenv.mkDerivation rec {
  pname = "pure-ffi";
  version = "0.14";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-ffi-${version}.tar.gz";
    sha256 = "0331f48efaae40af21b23cf286fd7eac0ea0a249d08fd97bf23246929c0ea71a";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure libffi ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "Provides an interface to libffi which enables you to call C functions from Pure and vice versa";
    homepage = "http://puredocs.bitbucket.org/pure-ffi.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
