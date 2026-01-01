{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "uefi-run";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Richard-W";
    repo = "uefi-run";
    rev = "v${version}";
    hash = "sha256-tR547osqw18dCMHJLqJ8AQBelbv8yCl7rAqslu+vnDQ=";
  };

  cargoHash = "sha256-c9aooU60zN58/m8q4G/f8VOjq7oXUTqxqSUMp47YOcA=";

<<<<<<< HEAD
  meta = {
    description = "Directly run UEFI applications in qemu";
    homepage = "https://github.com/Richard-W/uefi-run";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Directly run UEFI applications in qemu";
    homepage = "https://github.com/Richard-W/uefi-run";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "uefi-run";
  };
}
