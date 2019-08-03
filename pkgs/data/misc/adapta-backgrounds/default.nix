{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib }:

stdenv.mkDerivation rec {
  pname = "adapta-backgrounds";
  version = "0.5.3.1";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-backgrounds";
    rev = version;
    sha256 = "04hmbmzf97rsii8gpwy3wkljy5xhxmlsl34d63s6hfy05knclydj";
  };

  nativeBuildInputs = [ meson ninja pkgconfig glib ];

  meta = with stdenv.lib; {
    description = "Wallpaper collection for adapta-project";
    homepage = "https://github.com/adapta-project/adapta-backgrounds";
    license = with licenses; [ gpl2 cc-by-sa-40 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
