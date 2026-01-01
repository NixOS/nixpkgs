{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  lz4,
  python-lzo,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  setuptools-scm,
  zstandard,
}:

buildPythonPackage rec {
  pname = "dissect-squashfs";
<<<<<<< HEAD
  version = "1.11";
  pyproject = true;

=======
  version = "1.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.squashfs";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-glmrsbNkhgYBhcL+qgEnBfJnGL4ViHH1L5HN9rGlUNM=";
=======
    hash = "sha256-DFcC633TboQAwpLUKlRsVLN4PBGS8acOh/zCrv8ao8Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  optional-dependencies = {
    full = [
      lz4
      python-lzo
      zstandard
    ];
  };

  pythonImportsCheck = [ "dissect.squashfs" ];

<<<<<<< HEAD
  meta = {
    description = "Dissect module implementing a parser for the SquashFS file system";
    homepage = "https://github.com/fox-it/dissect.squashfs";
    changelog = "https://github.com/fox-it/dissect.squashfs/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Dissect module implementing a parser for the SquashFS file system";
    homepage = "https://github.com/fox-it/dissect.squashfs";
    changelog = "https://github.com/fox-it/dissect.squashfs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
