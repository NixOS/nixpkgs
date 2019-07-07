{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tinyscheme-${version}";
  version = "1.41";

  src = fetchurl {
    url = "mirror://sourceforge/tinyscheme/${name}.tar.gz";
    sha256 = "168rk4zrlhsknbvldq2jsgabpwlqkx6la44gkqmijmf7jhs11h7a";
  };

  patchPhase = ''
    substituteInPlace scheme.c --replace "init.scm" "$out/lib/init.scm"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp init.scm $out/lib
    cp scheme $out/bin/tinyscheme
  '';

  meta = with stdenv.lib; {
    description = "Lightweight Scheme implementation";
    longDescription = ''
      TinyScheme is a lightweight Scheme interpreter that implements as large a
      subset of R5RS as was possible without getting very large and complicated.
    '';
    homepage = http://tinyscheme.sourceforge.net/;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };
}
