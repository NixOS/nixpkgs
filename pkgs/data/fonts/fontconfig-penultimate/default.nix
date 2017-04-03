{ stdenv, fetchFromGitHub }:

let version = "0.3.2"; in
stdenv.mkDerivation {
  name = "fontconfig-penultimate-${version}";

  src = fetchFromGitHub {
    owner = "ttuegel";
    repo = "fontconfig-penultimate";
    rev = version;
    sha256 = "01cgqdmgpqahkg71lnvr3yzsmka9q1kgkbiz6w5ds1fhrpcswj7p";
  };

  installPhase = ''
    mkdir -p $out/etc/fonts/conf.d
    cp *.conf $out/etc/fonts/conf.d
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ttuegel/fontconfig-penultimate;
    description = "Sensible defaults for Fontconfig";
    license = licenses.asl20;
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.all;
  };
}
