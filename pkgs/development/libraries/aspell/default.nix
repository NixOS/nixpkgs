{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "aspell-0.60.6.1";

  src = fetchurl {
    url = "mirror://gnu/aspell/${name}.tar.gz";
    sha256 = "1qgn5psfyhbrnap275xjfrzppf5a83fb67gpql0kfqv37al869gm";
  };

  patchPhase = ''
    patch interfaces/cc/aspell.h < ${./clang.patch}
  '';

  buildInputs = [ perl ];

  doCheck = true;

  preConfigure = ''
    configureFlagsArray=(
      --enable-pkglibdir=$out/lib/aspell
      --enable-pkgdatadir=$out/lib/aspell
    );
  '';

  postInstall = ''
    local prog="$out/bin/aspell"
    local hidden="$out/bin/.aspell-wrapped"
    mv "$prog" "$hidden"
    cat > "$prog" <<END
    #! $SHELL -e
    if [ -z "\$ASPELL_CONF" ]; then
      for p in \$NIX_PROFILES; do
        if [ -d "\$p/lib/aspell" ]; then
          ASPELL_CONF="data-dir \$p/lib/aspell"
        fi
      done
      if [ -z "\$ASPELL_CONF" ] && [ -d "\$HOME/.nix-profile/lib/aspell" ]; then
        ASPELL_CONF="data-dir \$HOME/.nix-profile/lib/aspell"
      fi
      export ASPELL_CONF
    fi
    exec "$hidden" "\$@"
    END
    chmod +x "$prog"
  '';

  meta = {
    description = "Spell checker for many languages";
    homepage = http://aspell.net/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = with stdenv.lib.platforms; all;
  };
}
