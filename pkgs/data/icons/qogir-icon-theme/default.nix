{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "qogir-icon-theme";
  version = "2020-02-21";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0m7f26dzzz5gkxi9dbbc96pl0xcvayr1ibxbjkrlsjcdvfg7p3rr";
  };

  nativeBuildInputs = [ gtk3 ];

  dontDropIconThemeCache = true;

  installPhase = ''
    patchShebangs install.sh
    mkdir -p $out/share/icons
    name= ./install.sh -d $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "Flat colorful design icon theme";
    homepage = "https://github.com/vinceliuice/Qogir-icon-theme";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
