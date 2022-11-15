{lib, stdenv, fetchFromGitHub, autoreconfHook
, drmSupport ? false # Digital Radio Mondiale
}:

with lib;
stdenv.mkDerivation rec {
  pname = "faad2";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = version;
    sha256 = "sha256-k7y12OwCn3YkNZY9Ov5Y9EQtlrZh6oFUzM27JDR960w=";
  };

  configureFlags = []
    ++ optional drmSupport "--with-drm";

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "An open source MPEG-4 and MPEG-2 AAC decoder";
    homepage = "https://sourceforge.net/projects/faac/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    mainProgram = "faad";
    platforms   = platforms.all;
  };
}
