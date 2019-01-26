{ stdenv, rpmextract, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "0.701";
  name = "vegur-font-${version}";

  # Upstream doesn't version their URLs.
  # http://dotcolon.net/font/vegur/ → http://dotcolon.net/DL/font/vegur.zip
  src = fetchurl {
    url = "http://download.opensuse.org/repositories/M17N:/fonts/SLE_12_SP3/src/dotcolon-vegur-fonts-0.701-1.4.src.rpm";
    sha256 = "0ra3fds3b352rpzn0015km539c3l2ik2lqd5x6fr65ss9fg2xn34";
  };

  nativeBuildInputs = [ rpmextract unzip ];

  unpackPhase = ''
    rpmextract $src
    unzip vegur.zip
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/Vegur
    cp *.otf $out/share/fonts/Vegur
  '';

  meta = with stdenv.lib; {
    homepage = http://dotcolon.net/font/vegur/;
    description = "A humanist sans serif font.";
    platforms = platforms.all;
    maintainers = [ maintainers.samueldr ];
    license = licenses.cc0;
  };
}
