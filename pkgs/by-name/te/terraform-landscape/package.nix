{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "terraform_landscape";

  gemdir = ./.;
  exes = [ "landscape" ];

  passthru.updateScript = bundlerUpdateScript "terraform-landscape";

  meta = {
    description = "Improve Terraform's plan output to be easier to read and understand";
    homepage = "https://github.com/coinbase/terraform-landscape";
    license = with lib.licenses; asl20;
    maintainers = with lib.maintainers; [
      mbode
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
