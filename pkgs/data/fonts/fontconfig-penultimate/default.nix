{ stdenv, fetchFromGitHub }:

let version = "0.3.3"; in
stdenv.mkDerivation {
  name = "fontconfig-penultimate-${version}";

  src = fetchFromGitHub {
    owner = "ttuegel";
    repo = "fontconfig-penultimate";
    rev = version;
    sha256 = "0392lw31jps652dcjazln77ihb6bl7gk201gb7wb9i223avp86w9";
  };

  installPhase = ''
    mkdir -p $out/etc/fonts/conf.d
    cp *.conf $out/etc/fonts/conf.d
    # fix font priority issue https://github.com/bohoomil/fontconfig-ultimate/issues/173
    mv $out/etc/fonts/conf.d/{43,60}-wqy-zenhei-sharp.conf
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ttuegel/fontconfig-penultimate;
    description = "Sensible defaults for Fontconfig";
    license = licenses.asl20;
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.all;
  };
}
