{ stdenv, fetchFromGitHub }:

let version = "0.2.1"; in
stdenv.mkDerivation {
  name = "fontconfig-penultimate-${version}";

  src = fetchFromGitHub {
    owner = "ttuegel";
    repo = "fontconfig-penultimate";
    rev = version;
    sha256 = "14arpalmpn7ig2myxslk4jdg6lm0cnmwsxy7zl0j7yr417k1kprf";
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
