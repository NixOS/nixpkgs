{
  lib,
  stdenv,
  fetchFromGitea,
  jdupes,
}:

stdenv.mkDerivation rec {
  pname = "libjodycode";
  version = "3.1.1";

  outputs = [
    "out"
    "man"
    "dev"
  ];

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jbruchon";
    repo = "libjodycode";
    rev = "v${version}";
    hash = "sha256-sVEa2gNvgRJK1Ycmv4inbViTBPQFjzcZ8XHlAdsNzOk=";
  };

  env.PREFIX = placeholder "out";

  passthru.tests = {
    inherit jdupes;
  };

  meta = with lib; {
    description = "Shared code used by several utilities written by Jody Bruchon";
    homepage = "https://github.com/jbruchon/libjodycode";
    changelog = "https://github.com/jbruchon/libjodycode/blob/${src.rev}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
