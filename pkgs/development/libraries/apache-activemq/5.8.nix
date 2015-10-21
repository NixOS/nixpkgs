import ./recent.nix
  rec {
    version = "5.8.0";
    sha256 = "12a1lmmqapviqdgw307jm07vw1z5q53r56pkbp85w9wnqwspjrbk";
    mkUrl = name: "mirror://apache/activemq/apache-activemq/${version}/${name}-bin.tar.gz";
  }
