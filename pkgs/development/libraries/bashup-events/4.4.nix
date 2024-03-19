{ callPackage, fetchFromGitHub }:

callPackage ./generic.nix {
  variant = "4.4";
  version = "2020-04-04";
  branch = "bash44";
  src = fetchFromGitHub {
    owner = "bashup";
    repo = "events";
    rev = "e97654f5602fc4e31083b27afa18dcc89b3e8296";
    hash = "sha256-51OSIod3mEg3MKs4rrMgRcOimDGC+3UIr4Bl/cTRyGM=";
  };
  keep = {
    # allow vars in eval
    eval = [ "e" "bashup_ev" "n" ];
    # allow vars executed as commands
    "$f" = true;
    "$n" = true;
  };
}
