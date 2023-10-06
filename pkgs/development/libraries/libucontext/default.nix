{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libucontext";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "kaniini";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fk3ZKkp3dsyeF6SOWSccr5MkKEwS4AAuosD/h+6wjSw=";
  };

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/kaniini/libucontext";
    description = "ucontext implementation featuring glibc-compatible ABI";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = [ maintainers.yuka ];
  };
}
