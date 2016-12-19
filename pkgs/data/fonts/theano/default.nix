{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "theano-${version}";
  version = "2.0";

  src = fetchzip {
    stripRoot = false;
    url = "https://github.com/akryukov/theano/releases/download/v${version}/theano-${version}.otf.zip";
    sha256 = "1z3c63rcp4vfjyfv8xwc3br10ydwjyac3ipbl09y01s7qhfz02gp";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    find . -name "*.otf" -exec cp -v {} $out/share/fonts/opentype \;
    find . -name "*.txt" -exec cp -v {} $out/share/doc/${name} \;
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/akryukov/theano;
    description = "An old-style font designed from historic samples";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
