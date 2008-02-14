{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "aspell-0.60.5";
  
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.5.tar.gz;
    md5 = "17fd8acac6293336bcef44391b71e337";
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
