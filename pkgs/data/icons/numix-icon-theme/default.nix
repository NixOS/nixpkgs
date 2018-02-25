{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "numix-icon-theme";
  version = "17-12-25";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "0q3hpq2jc9iwnzzqpb12g1qzjsw4ckhdqkfqf6nirl87r5drkv6j";
  };

  nativeBuildInputs = [ gtk3 hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons
    mv Numix{,-Light} $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo jgeerds ];
  };
}
