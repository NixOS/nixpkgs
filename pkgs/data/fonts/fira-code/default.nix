{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-code-${version}";
  version = "1.203";

  src = fetchurl {
    url = "https://github.com/tonsky/FiraCode/releases/download/${version}/FiraCode_${version}.zip";
    sha256 = "0pjziaklmkpl67ybp45q9ndya5adf9x8svhdv9643dq9jsrxbkj1";
  };

  sourceRoot = "otf";

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v *.otf $out/share/fonts/opentype
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tonsky/FiraCode;
    description = "Monospace font with programming ligatures";
    longDescription = ''
      Fira Code is a monospace font extending the Fira Mono font with
      a set of ligatures for common programming multi-character
      combinations.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
