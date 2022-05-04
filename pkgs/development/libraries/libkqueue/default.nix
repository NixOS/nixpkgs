{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libkqueue";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "mheily";
    repo = "libkqueue";
    rev = "v${version}";
    sha256 = "sha256-qh1r95A/ngg4KWSVYlC8ldv2ClV+rRPNcJDH+aAGxHs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "kqueue(2) compatibility library";
    homepage = "https://github.com/mheily/libkqueue";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.linux;
  };
}
