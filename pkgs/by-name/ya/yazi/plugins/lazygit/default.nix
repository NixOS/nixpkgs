{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "lazygit.yazi";
<<<<<<< HEAD
  version = "0-unstable-2025-12-19";
=======
  version = "0-unstable-2025-08-06";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Lil-Dank";
    repo = "lazygit.yazi";
<<<<<<< HEAD
    rev = "ea20d05b4ede88a239830d2b50ba79b1860a3bee";
    hash = "sha256-uDRd2pDgvYAwrnsKg5U/Dj8ZPtNKzlJRg+YARKjSpCw=";
=======
    rev = "8f37dc5795f165021098b17d797c7b8f510aeca9";
    hash = "sha256-rR7SMTtQYrvQjhkzulDaNH/LAA77UnXkcZ50WwBX2Uw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Lazygit plugin for yazi";
    homepage = "https://github.com/Lil-Dank/lazygit.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
