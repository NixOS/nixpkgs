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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (ruby.meta) platforms;

    description = "Export existing AWS resources to Terraform style (tf, tfstate)";
    homepage = "https://github.com/dtan4/terraforming";
<<<<<<< HEAD
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ kalbasit ];
=======
    license = with licenses; mit;
    maintainers = with maintainers; [ kalbasit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
