{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
<<<<<<< HEAD
  version = "4.19.1";
=======
  version = "4.17.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-7BynMgcIhxKpKJ9NfWDxYj3G8/Zu9ZYV0pAG9tBOCtM=";
  };

  cargoHash = "sha256-qz9xkdw2+pdBts+onVUjtsoFIzG1uNVErsVNOznrP0E=";
=======
    sha256 = "sha256-NVNnkGWI2+lFfxpeUPFEVrr6QHj1U1jcyLXyFjGh5uo=";
  };

  cargoHash = "sha256-kFnMNl/s7n0VyPPt7ie3kZjC7y7ZB5HX6jUoBBTFp50=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
}
