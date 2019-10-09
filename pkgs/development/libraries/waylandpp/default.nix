{ stdenv, fetchFromGitHub, cmake, pkgconfig, pugixml, wayland, libGL }:

stdenv.mkDerivation rec {
  pname = "waylandpp";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = pname;
    rev = version;
    sha256 = "1lm8amlk70gmpj7ipdk2lg05b8dpbyd03sc4h38pm7n0cwxl15gp";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ pugixml wayland libGL ];

  meta = with stdenv.lib; {
    description = "Wayland C++ binding";
    homepage = https://github.com/NilsBrause/waylandpp/;
    license = with licenses; [ bsd2 hpnd ];
    maintainers = with maintainers; [ minijackson ];
  };
}
