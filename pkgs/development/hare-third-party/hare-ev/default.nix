{
  fetchFromSourcehut,
  hareHook,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "hare-ev";
  version = "0-unstable-2024-12-13";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ev";
    rev = "7f80dcbeb09f4dd743cdccfb2cfed10bfdeb07ab";
    hash = "sha256-cwBmkwQUeOBjTbDor44ZNowZkJ0ifrbr+ST5j5dUJm8=";
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
