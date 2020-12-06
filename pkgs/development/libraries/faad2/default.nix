{stdenv, fetchFromGitHub, autoreconfHook
, drmSupport ? false # Digital Radio Mondiale
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "faad2";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = builtins.replaceStrings [ "." ] [ "_" ] version;
    sha256 = "0q52kdd95ls6ihzyspx176wg9x22425v5qsknrmrjq30q25qmmlg";
  };

  configureFlags = []
    ++ optional drmSupport "--with-drm";

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "An open source MPEG-4 and MPEG-2 AAC decoder";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
