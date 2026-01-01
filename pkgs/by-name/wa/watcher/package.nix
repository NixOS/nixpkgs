{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "watcher";
<<<<<<< HEAD
  version = "0.14.1";
=======
  version = "0.13.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "e-dant";
    repo = "watcher";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Rqsm6DBS8SHxibQvrwO30RZ5ZPLWQvdTOM7i2zzCPXc=";
=======
    hash = "sha256-sQel+W9J8ExWkSEYd6Wjw2M9VgTIax+8zadI982fH4U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Filesystem watcher. Works anywhere. Simple, efficient and friendly";
    homepage = "https://github.com/e-dant/watcher";
    changelog = "https://github.com/e-dant/watcher/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gaelreyrol
      matthiasbeyer
    ];
    mainProgram = "tw";
    platforms = lib.platforms.all;
  };
}
