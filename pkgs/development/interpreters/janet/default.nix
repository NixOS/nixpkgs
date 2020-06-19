{ stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kx3c4v0481b4xx239w10ajwp8ngq8smxzh3m77dazd89r997n1g";
  };

  nativeBuildInputs = [ meson ninja ];
  mesonFlags = [ "-Dgit_hash=release" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Janet programming language";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrewchambers ];
  };
}
