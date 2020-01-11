{ stdenv, fetchFromGitHub, cmake } :

let
  version = "0.9.2";

in stdenv.mkDerivation {
  pname = "codec2";
  inherit version;

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = "v${version}";
    sha256 = "1jpvr7bra8srz8jvnlbmhf8andbaavq5v01qjnp2f61za93rzwba";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = http://www.rowetel.com/blog/?page_id=452;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ markuskowa ];
  };
}
