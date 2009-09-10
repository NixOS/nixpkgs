args: with args;
stdenv.mkDerivation {
  name = "boolstuff-0.1.12";

  src = fetchurl {
    url = http://perso.b2b2c.ca/sarrazip/dev/boolstuff-0.1.12.tar.gz;
    sha256 = "0h39civar6fjswaf3bn1r2ddj589rya0prd6gzsyv3qzr9srprq9";
  };

  buildInputs = [pkgconfig];

  meta = { 
    description = "operations on boolean expression binary trees";
    homepage = http://perso.b2b2c.ca/sarrazip/dev/boolstuff.html;
    license = "GPL";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
