{ stdenv, fetchFromGitHub, cmake, pkgconfig, pugixml, wayland, libGL }:

stdenv.mkDerivation rec {
  pname = "waylandpp";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = pname;
    rev = version;
    sha256 = "16h57hzd688664qcyznzhjp3hxipdkzgv46x82yhkww24av8b55n";
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
