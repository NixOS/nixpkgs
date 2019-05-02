{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nahid-fonts";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "nahid-font";
    rev = "v${version}";
    sha256 = "0n42sywi41zin9dilr8vabmcqvmx2f1a8b4yyybs6ms9zb9xdkxg";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/nahid-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/nahid-fonts
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/rastikerdar/nahid-font;
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی ناهید";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
