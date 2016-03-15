import ./recent.nix
  rec {
    version = "5.12.1";
    sha256 = "1hn6pls12dzc2fngz6lji7kmz7blvd3z1dq4via8gd4fjflmw5c9";
    mkUrl = name: "mirror://apache/activemq/${version}/${name}-bin.tar.gz";
  }
