{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "7.0.0beta1";
  url = "https://downloads.php.net/~ab/php-7.0.0beta1.tar.bz2";
  sha = "1pj3ysfhswg2r370ivp33fv9zbcl3yvhmxgnc731k08hv6hmd984";
  apacheHttpd = apacheHttpd;
  php7 = true;
}
