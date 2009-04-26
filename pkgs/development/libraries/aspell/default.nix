{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "aspell-0.60.6";
  
  src = fetchurl {
    url = "ftp://ftp.gnu.org/gnu/aspell/${name}.tar.gz";
    sha256 = "0dhfgkp2y16z0agdvhn4iaikr34l4agjz2nannqvpxkcw8h1ansg";
  };
  
  buildInputs = [perl];

  # Note: Users should define the `ASPELL_CONF' environment variable to
  # `dict-dir $HOME/.nix-profile/lib/aspell/' so that they can access
  # dictionaries installed in their profile.
  #
  # We can't use `$out/etc/aspell.conf' for that purpose since Aspell
  # doesn't expand environment variables such as `$HOME'.

  meta = {
    description = "GNU Aspell, A spell checker for many languages";
    homepage = http://aspell.net/;
    license = "LGPL";
  };
}
