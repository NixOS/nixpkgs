{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, libpcap }:

stdenv.mkDerivation rec {
  pname = "libcrafter";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "pellegre";
    repo = "libcrafter";
    rev = "version-${version}";
    sha256 = "sha256-tCdN3+EzISVl+wp5umOFD+bgV+uUdabH+2LyxlV/W7Q=";
  };

  preConfigure = "cd libcrafter";

  configureScript = "./autogen.sh";

  configureFlags = [ "--with-libpcap=yes" ];

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libtool ];

  propagatedBuildInputs = [ libpcap ];

  meta = {
    homepage = "https://github.com/pellegre/libcrafter";
    description = "High level C++ network packet sniffing and crafting library";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
