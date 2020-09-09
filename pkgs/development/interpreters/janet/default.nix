{ stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "18k6dzxzr149p0bby4r0z6kybylig87rwj7gk3z6a98zf6k4xmsw";
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
