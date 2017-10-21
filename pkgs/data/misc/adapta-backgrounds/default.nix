{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "adapta-backgrounds-${version}";
  version = "0.4.0.6";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-backgrounds";
    rev = version;
    sha256 = "1yqxrwhjl6g92wm52kalbns41i2l5g45qbd4185b22crhbrn5x79";
  };

  nativeBuildInputs = [ autoreconfHook  ];

  meta = with stdenv.lib; {
    description = "A wallpaper collection for adapta-project";
    homepage = https://github.com/adapta-project/adapta-backgrounds;
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
