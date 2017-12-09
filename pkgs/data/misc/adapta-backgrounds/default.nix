{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "adapta-backgrounds-${version}";
  version = "0.5.1.1";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-backgrounds";
    rev = version;
    sha256 = "00gwiraq6c9jh1xl5mmmi5fdj9l3r75ii5wk8jnw856qvrajhxyq";
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
