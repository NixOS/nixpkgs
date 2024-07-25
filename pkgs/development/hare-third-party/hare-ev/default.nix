{
  fetchFromSourcehut,
  hareHook,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "hare-ev";
  version = "0-unstable-2024-07-07";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ev";
    rev = "aa01cdd0ba226ed9a4c5e6031e6aa7158aa05c9a";
    hash = "sha256-xq6d2+BbHk2iLg50mtqXqhkky/P9GeRAulSD7ouMnrA=";
  };

  nativeCheckInputs = [ hareHook ];

  makeFlags = [ "PREFIX=${builtins.placeholder "out"}" ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Event loop for Hare programs";
    homepage = "https://sr.ht/~sircmpwn/hare-ev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ colinsane ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
}
