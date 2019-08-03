args @ { fetchurl, ... }:
rec {
  baseName = ''swank'';
  version = ''slime-v2.23'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/slime/2019-01-07/slime-v2.23.tgz'';
    sha256 = ''1ml602yq5s38x0syg0grik8i4h01jw06yja87vpkjl3mkxqvxvky'';
  };

  packageName = "swank";

  asdFilesToKeep = ["swank.asd"];
  overrides = x: x;
}
/* (SYSTEM swank DESCRIPTION NIL SHA256
    1ml602yq5s38x0syg0grik8i4h01jw06yja87vpkjl3mkxqvxvky URL
    http://beta.quicklisp.org/archive/slime/2019-01-07/slime-v2.23.tgz MD5
    726724480d861d97e8b58bc8f9f27697 NAME swank FILENAME swank DEPS NIL
    DEPENDENCIES NIL VERSION slime-v2.23 SIBLINGS NIL PARASITES NIL) */
