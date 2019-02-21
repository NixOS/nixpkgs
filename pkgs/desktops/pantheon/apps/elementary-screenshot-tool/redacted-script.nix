{ stdenv, fetchFromGitHub, pantheon }:

stdenv.mkDerivation rec {
  name = "elementary-redacted-script-${version}";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "fonts";
    rev = version;
    sha256 = "16x2w7w29k4jx2nwc5932h9rqvb216vxsziazisv2rpll74kn8b2";
  };

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/redacted-elementary
    cp -a redacted/*.ttf $out/share/fonts/truetype/redacted-elementary
  '';

  meta = with stdenv.lib; {
    description = "Redacted Script Font for elementary";
    homepage = https://github.com/elementary/fonts;
    license = licenses.ofl;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
