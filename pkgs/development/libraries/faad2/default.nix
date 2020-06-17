{stdenv, fetchFromGitHub, autoreconfHook
, drmSupport ? false # Digital Radio Mondiale
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "faad2";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = builtins.replaceStrings [ "." ] [ "_" ] version;
    sha256 = "0rdi6bmyryhkwf4mpprrsp78m6lv1nppav2f0lf1ywifm92ng59c";
  };

  configureFlags = []
    ++ optional drmSupport "--with-drm";

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "An open source MPEG-4 and MPEG-2 AAC decoder";
    homepage    = "https://www.audiocoding.com/faad2.html";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
