{ sqlite, fetchFromGitHub, tcl }:

let
  version = "3.29.0+replication3";
  name = "sqlite-${version}";

in sqlite.overrideAttrs (oldAttrs: {
  inherit name version;

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = "sqlite";
    rev = "version-${version}";
    sha256 = "1jfzpdxwa2lc584ay20gmyd284r4fllps2iwgbi3fdbzcz6g6knd";
  };

  nativeBuildInputs = [ tcl ];

  configureFlags = oldAttrs.configureFlags ++ [
      "--enable-replication"
      "--disable-amalgamation"
      "--disable-tcl"
  ];

})
