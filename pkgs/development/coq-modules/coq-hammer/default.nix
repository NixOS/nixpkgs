{ mkCoqDerivation, coq, coq-hammer-tactics, version ? null }:

mkCoqDerivation {
  inherit version;
  pname = "coq-hammer";
  inherit (coq-hammer-tactics) owner repo defaultVersion release releaseRev;

  buildFlags = [ "plugin" ];
  installTargets = [ "install-plugin" ];
  extraInstallFlags = [ "BINDIR=$(out)/bin/" ];

  mlPlugin = true;

  propagatedBuildInputs = [ coq.ocamlPackages.findlib coq-hammer-tactics ];

  meta = coq-hammer-tactics.meta // {
    description = "General-purpose automated reasoning hammer tool for Coq";
  };
}
