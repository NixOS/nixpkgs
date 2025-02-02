{
  fetchFromSourcehut,
  hareHook,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "hare-ev";
  version = "0-unstable-2024-12-29";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ev";
    rev = "48bf3855a48467579321ba56c3406e574b046638";
    hash = "sha256-fWdmZj8j3CSVsWX7Yxf42iGwSZc0ae5/hTNtdeo9dkw=";
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
