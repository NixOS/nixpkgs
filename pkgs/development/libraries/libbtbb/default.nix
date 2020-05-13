{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libbtbb";
  version = "2018-12-R1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = pname;
    rev = version;
    sha256 = "07g7yapnbfgm7by8i2ppvx8s66jzha61d1bvm064jb2yi1734ppr";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Bluetooth baseband decoding library";
    homepage = "https://github.com/greatscottgadgets/libbtbb";
    license = licenses.gpl2;
    maintainers = with maintainers; [ oxzi ];
  };
}
