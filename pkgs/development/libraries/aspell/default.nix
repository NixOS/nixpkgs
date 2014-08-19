{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "aspell-0.60.6.1";

  src = fetchurl {
    url = "mirror://gnu/aspell/${name}.tar.gz";
    sha256 = "1qgn5psfyhbrnap275xjfrzppf5a83fb67gpql0kfqv37al869gm";
  };

  buildInputs = [ perl ];

  doCheck = true;

  preConfigure = ''
    configureFlagsArray=(
      --enable-pkglibdir=$out/lib/aspell
      --enable-pkgdatadir=$out/lib/aspell
    );
  '';

  # Note: Users should define the `ASPELL_CONF' environment variable to
  # `dict-dir $HOME/.nix-profile/lib/aspell/' so that they can access
  # dictionaries installed in their profile.
  #
  # We can't use `$out/etc/aspell.conf' for that purpose since Aspell
  # doesn't expand environment variables such as `$HOME'.

  meta = {
    description = "Spell checker for many languages";
    homepage = http://aspell.net/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ ];
  };
}
