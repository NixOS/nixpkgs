{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  ruby,
}:

bundlerApp rec {
  inherit ruby;

  pname = "terraforming";
  gemdir = ./.;
  exes = [ "terraforming" ];

  passthru.updateScript = bundlerUpdateScript "terraforming";

  meta = {
    inherit (ruby.meta) platforms;

    description = "Export existing AWS resources to Terraform style (tf, tfstate)";
    homepage = "https://github.com/dtan4/terraforming";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
}
