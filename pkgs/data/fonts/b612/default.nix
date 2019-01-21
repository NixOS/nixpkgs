{ stdenv, fetchgit }:
stdenv.mkDerivation {
  name = "b612-font-2019-01-21";

  src = fetchgit {
    url = "git://git.polarsys.org/gitroot/b612/b612.git";
    rev = "bd14fde2544566e620eab106eb8d6f2b7fb1347e";
    sha256 = "1w1w9za599w3asmdkhng9amb9w0riq6mg400p43w1qnj0zqazy3d";
  };

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/share/fonts
    cp ./TTF/*.ttf $out/share/fonts
  '';

  meta = {
    description = "a highly legible open source font family designed and tested to be used on aircraft cockpit screens";
    homepage = "http://b612-font.com/";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.epl10;
    maintainers = [ stdenv.lib.maintainers.grahamc ];
  };
}
