/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "net-telent-date";
  version = "net-telent-date_0.42";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/net-telent-date/2010-10-06/net-telent-date_0.42.tgz";
    sha256 = "06vdlddwi6kx999n1093chwgw0ksbys4j4w9i9zqvw768wxp4li1";
  };

  packageName = "net-telent-date";

  asdFilesToKeep = ["net-telent-date.asd"];
  overrides = x: x;
}
/* (SYSTEM net-telent-date DESCRIPTION System lacks description SHA256
    06vdlddwi6kx999n1093chwgw0ksbys4j4w9i9zqvw768wxp4li1 URL
    http://beta.quicklisp.org/archive/net-telent-date/2010-10-06/net-telent-date_0.42.tgz
    MD5 6fedf40113b2462f7bd273d07950066b NAME net-telent-date FILENAME
    net-telent-date DEPS NIL DEPENDENCIES NIL VERSION net-telent-date_0.42
    SIBLINGS NIL PARASITES NIL) */
