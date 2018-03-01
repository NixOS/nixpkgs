{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "adapta-backgrounds-${version}";
  version = "0.5.2.3";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-backgrounds";
    rev = version;
    sha256 = "0n0ggcxinja81lasmpviqq3l4jiwb05bs8r5aah1im2zvls1g007";
  };

  nativeBuildInputs = [ autoreconfHook  ];

  meta = with stdenv.lib; {
    description = "Wallpaper collection for adapta-project";
    homepage = https://github.com/adapta-project/adapta-backgrounds;
    license = with licenses; [ gpl2 cc-by-sa-40 ];
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
