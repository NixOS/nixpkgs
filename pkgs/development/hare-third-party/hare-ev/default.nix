{ stdenv
, lib
, fetchFromSourcehut
, hare
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "hare-ev";
  version = "unstable-2023-10-31";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ev";
    rev = "9bdbd02401334b7d762131a46e64ca2cd24846dc";
    hash = "sha256-VY8nsy5kLDMScA2ig3Rgbkf6VQlCTnGWjzGvsI9OcaQ=";
  };

  nativeCheckInputs = [
    hare
  ];

  makeFlags = [
    "HARECACHE=.harecache"
    "PREFIX=${builtins.placeholder "out"}"
  ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Event loop for Hare programs";
    homepage = "https://sr.ht/~sircmpwn/hare-ev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ colinsane ];
    inherit (hare.meta) platforms badPlatforms;
  };
}
