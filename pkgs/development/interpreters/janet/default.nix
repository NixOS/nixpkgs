{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lE2BAwiwvewydIpVYoN+zrfpzQbMbe5Nb1r0mzdxMao=";
  };

  nativeBuildInputs = [ meson ninja ];
  mesonFlags = [ "-Dgit_hash=release" ];

  doCheck = true;

  meta = with lib; {
    description = "Janet programming language";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrewchambers ];
  };
}
