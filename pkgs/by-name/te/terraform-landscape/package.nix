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

<<<<<<< HEAD
  meta = {
    description = "Improve Terraform's plan output to be easier to read and understand";
    homepage = "https://github.com/coinbase/terraform-landscape";
    license = with lib.licenses; asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Improve Terraform's plan output to be easier to read and understand";
    homepage = "https://github.com/coinbase/terraform-landscape";
    license = with licenses; asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mbode
      manveru
      nicknovitski
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
