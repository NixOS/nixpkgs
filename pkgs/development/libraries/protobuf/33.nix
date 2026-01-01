{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
<<<<<<< HEAD
    version = "33.2";
    hash = "sha256-SguWBa9VlE15C+eLzcqqusVLgx9kDyPXwYImSE75HCM=";
=======
    version = "33.1";
    hash = "sha256-IW6wLkr/NwIZy5N8s+7Fe9CSexXgliW8QSlvmUD+g5Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  }
  // args
)
