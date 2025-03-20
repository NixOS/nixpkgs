{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  sqlite,
}:

buildGoModule rec {
  pname = "textql";
  version = "unstable-2021-07-06";

  src = fetchFromGitHub {
    owner = "dinedal";
    repo = "textql";
    rev = "fca00ecc76c8d9891b195ad2c1359d39f0213604";
    hash = "sha256-NccRo5YdhwTo2eez5UE5nI3TEqzTL1rjPO1kKfDBNuw=";
  };

  patches = [
    # fix build with go 1.17
    (fetchpatch {
      url = "https://github.com/jawn-smith/textql/commit/a0d7038c8c30671dfd618f47322814ab492c11a1.patch";
      sha256 = "1yjdbwipjxxhfcqlj1z6ngsm7dr8gfp4l61jynn2iw7f02cn1yck";
    })
  ];

  vendorHash = "sha256-/DFtZA3Tml+RYTuv1YEUnC37jChTjrC01+zRO7Tj58A=";

  postInstall = ''
    install -Dm644 -t $out/share/man/man1 ${src}/man/textql.1
  '';

  # needed for tests
  nativeBuildInputs = [ sqlite ];

  doCheck = true;

  meta = with lib; {
    description = "Execute SQL against structured text like CSV or TSV";
    mainProgram = "textql";
    homepage = "https://github.com/dinedal/textql";
    license = licenses.mit;
    maintainers = [ ];
  };
}
