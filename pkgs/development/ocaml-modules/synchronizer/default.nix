{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  prelude,
<<<<<<< HEAD
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "synchronizer";
  version = "0.2";
=======
}:

buildDunePackage rec {
  pname = "synchronizer";
  version = "0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "synchronizer";
<<<<<<< HEAD
    tag = "${finalAttrs.version}";
    hash = "sha256-0XtPHpDlyH1h8W2ZlRvJbZjCN9WP5mzk2N01WFd8eLQ=";
=======
    tag = version;
    hash = "sha256-VlKqORXTXafT88GXHIYkz+A1VkEL3jP9SMqDdMyEdrw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    prelude
  ];

<<<<<<< HEAD
  checkInputs = [
    alcotest
  ];

  meta = {
    homepage = "https://github.com/OCamlPro/synchronizer";
    description = "Synchronizer to make datastructures thread-safe";
    changelog = "https://raw.githubusercontent.com/OCamlPro/synchronizer/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
=======
  meta = {
    homepage = "https://github.com/OCamlPro/synchronizer";
    description = "Synchronizer to make datastructures thread-safe";
    changelog = "https://raw.githubusercontent.com/OCamlPro/synchronizer/${src.rev}/CHANGES.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ redianthus ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
