{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "behdad-fonts";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "font-store";
    repo = "BehdadFont";
    rev = "v${version}";
    sha256 = "0rlmyv82qmyy90zvkjnlva44ia7dyhiyk7axbq526v7zip3g79w0";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/behdad-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/behdad-fonts
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/font-store/BehdadFont;
    description = "A Persian/Arabic Open Source Font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
