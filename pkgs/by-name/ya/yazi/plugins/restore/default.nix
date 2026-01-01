{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
<<<<<<< HEAD
  version = "25.5.31-unstable-2025-12-04";
=======
  version = "25.5.31-unstable-2025-09-25";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
<<<<<<< HEAD
    rev = "6395e52b3af3a8832f0249970a168c41fb92b31b";
    hash = "sha256-HfXhYe3XPKkd/ivpQB85EsZyvLiflJE0tRNGVid2A9A=";
=======
    rev = "2161735f840e36974a6b4b0007c3e4184a085208";
    hash = "sha256-W3P7UhEtmv0JfcKUd+g/HBPy4ML8qgmgnOVaYKN0TSU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
