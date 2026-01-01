{
  fetchFromGitHub,
  ...
}:

rec {
<<<<<<< HEAD
  version = "0.10.7";
=======
  version = "0.10.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aUhxaxniGcmFAawUTXa5QrWUSpw5NUoJO5y4INk5mQU=";
=======
    hash = "sha256-iJEkfW60QO4nFp+ib2+DeDRsZviYFhWRQoBw1VAhzJY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
