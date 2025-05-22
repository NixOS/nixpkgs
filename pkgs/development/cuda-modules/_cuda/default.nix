rec {
  bootstrapData = import ./db/bootstrap/static.nix;
  dbEvaluation = import ./db { };
  db = dbEvaluation.config;
}
