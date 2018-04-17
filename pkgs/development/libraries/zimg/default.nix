{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec{
  name = "zimg-${version}";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner  = "sekrit-twc";
    repo   = "zimg";
    rev    = "release-${version}";
    sha256 = "1gpmf6algpl1g1z891jfnsici84scg2cq1kj4v90glgik9z99mci";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Scaling, colorspace conversion and dithering library";
    homepage    = https://github.com/sekrit-twc/zimg;
    license     = licenses.wtfpl;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
