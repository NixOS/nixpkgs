{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "zimg";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner  = "sekrit-twc";
    repo   = "zimg";
    rev    = "release-${version}";
    sha256 = "0jlgrlfs9maixd8mx7gk2kfawz8ixnihkxi7vhyzfy1gq49vmxm2";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Scaling, colorspace conversion and dithering library";
    homepage    = https://github.com/sekrit-twc/zimg;
    license     = licenses.wtfpl;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
