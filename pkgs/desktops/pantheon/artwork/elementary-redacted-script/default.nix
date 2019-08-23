{ stdenv
, fetchFromGitHub
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "elementary-redacted-script";
  version = "unstable-2016-06-03";

  src = fetchFromGitHub {
    owner = "png2378";
    repo = "redacted-elementary";
    rev = "346440ff9ce19465e6d5c3d6d67a8573f992c746";
    sha256 = "1jpd13sxkarclr0mlm66wzgpjh52ghzjzn4mywhyshyyskwn7jg1";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/redacted-elementary
    cp -a truetype/*.ttf $out/share/fonts/truetype/redacted-elementary
  '';

  meta = with stdenv.lib; {
    description = "Font for concealing text";
    homepage = https://github.com/png2378/redacted-elementary;
    license = licenses.ofl;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
