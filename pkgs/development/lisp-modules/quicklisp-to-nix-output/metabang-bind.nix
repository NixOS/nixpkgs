args @ { fetchurl, ... }:
rec {
  baseName = ''metabang-bind'';
  version = ''20170124-git'';

  description = ''Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/metabang-bind/2017-01-24/metabang-bind-20170124-git.tgz'';
    sha256 = ''1xyiyrc9c02ylg6b749h2ihn6922kb179x7k338dmglf4mpyqxwc'';
  };

  packageName = "metabang-bind";

  asdFilesToKeep = ["metabang-bind.asd"];
  overrides = x: x;
}
/* (SYSTEM metabang-bind DESCRIPTION
    Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.
    SHA256 1xyiyrc9c02ylg6b749h2ihn6922kb179x7k338dmglf4mpyqxwc URL
    http://beta.quicklisp.org/archive/metabang-bind/2017-01-24/metabang-bind-20170124-git.tgz
    MD5 20c6a434308598ad7fa224d99f3bcbf6 NAME metabang-bind FILENAME
    metabang-bind DEPS NIL DEPENDENCIES NIL VERSION 20170124-git SIBLINGS
    (metabang-bind-test) PARASITES NIL) */
