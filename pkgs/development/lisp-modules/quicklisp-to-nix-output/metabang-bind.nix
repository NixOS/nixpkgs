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

  overrides = x: {
  };
}
