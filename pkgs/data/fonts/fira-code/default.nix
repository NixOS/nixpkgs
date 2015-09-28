{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fira-code-${version}";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/tonsky/FiraCode/releases/download/${version}/FiraCode-Regular.otf";
    sha256 = "1blalxnmrxqlm5i74jhm8j29n0zsnmqi3gppxa9szjzv4x2k5s0a";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v $src $out/share/fonts/opentype/FiraCode-Regular.otf
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
