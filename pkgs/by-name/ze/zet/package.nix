{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch2
}:

rustPlatform.buildRustPackage rec {
  pname = "zet";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "yarrow";
    repo = "zet";
    rev = "v${version}";
    hash = "sha256-IjM+jSb+kdML0zZGuz9+9wrFzQCujn/bg9/vaTzMtUs=";
  };

  patches = [
    # fix unused_qualifications lint with rust 1.78+
    # https://github.com/yarrow/zet/commit/b6a0c67f6ac76fb7bf8234951678b77fbac12d76
    (fetchpatch2 {
      url = "https://github.com/yarrow/zet/commit/b6a0c67f6ac76fb7bf8234951678b77fbac12d76.patch?full_index=1";
      hash = "sha256-HojhKM7UJh5xpD9a18Wh0hiiUDOE+jK0BKGYozYjMBc=";
    })
  ];

  cargoHash = "sha256-kHIOsSR7ZxBzp4dtm2hbi8ddtlQ86x5EASk5HFmnhFo=";

  # tests fail with `--release`
  # https://github.com/yarrow/zet/pull/7
  checkType = "debug";

  meta = with lib; {
    description = "CLI utility to find the union, intersection, set difference, etc of files considered as sets of lines";
    mainProgram = "zet";
    homepage = "https://github.com/yarrow/zet";
    changelog = "https://github.com/yarrow/zet/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
