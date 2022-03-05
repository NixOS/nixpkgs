{ lib, stdenv, fetchurl, pkg-config, pure, sqlite }:

stdenv.mkDerivation rec {
  pname = "pure-sql3";
  version = "0.5";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-sql3-${version}.tar.gz";
    sha256 = "b9f79dd443c8ffc5cede51e2af617f24726f5c0409aab4948c9847e6adb53c37";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure sqlite ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A SQLite module for the Pure programming language";
    homepage = "http://puredocs.bitbucket.org/pure-sql3.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
