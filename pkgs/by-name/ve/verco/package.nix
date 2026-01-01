{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "verco";
  version = "6.12.0";

  src = fetchFromGitHub {
    owner = "vamolessa";
    repo = "verco";
    rev = "v${version}";
    sha256 = "sha256-M3Utrt350I67kqzEH130tgBIiI7rY8ODCSxgMohWWWM=";
  };

  cargoHash = "sha256-cpPEIFoEqc/4Md+/5e09B/ZQ+7cflLE+PY4ATAgWUvo=";

<<<<<<< HEAD
  meta = {
    description = "Simple Git/Mercurial/PlasticSCM tui client based on keyboard shortcuts";
    homepage = "https://vamolessa.github.io/verco";
    license = lib.licenses.gpl3Only;
=======
  meta = with lib; {
    description = "Simple Git/Mercurial/PlasticSCM tui client based on keyboard shortcuts";
    homepage = "https://vamolessa.github.io/verco";
    license = licenses.gpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "verco";
  };
}
