{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zfind";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "laktak";
    repo = "zfind";
    rev = "v${version}";
    hash = "sha256-zp2YrrvghmXy0LPxCSkOxYwrmoGabTKCD5CiFl3XCOU=";
  };

  vendorHash = "sha256-kSqzjRXCr92c6CzQpRf3Ny+SEp3O15fKk0NgmTHtxSY=";

  ldflags = [
    "-X"
    "main.appVersion=${version}"
  ];

  meta = {
    description = "CLI for file search with SQL like syntax";
    longDescription = ''
      zfind allows you to search for files, including inside tar, zip, 7z and rar archives.
      It makes finding files easy with a filter syntax that is similar to an SQL-WHERE clause.
    '';
    homepage = "https://github.com/laktak/zfind";
    changelog = "https://github.com/laktak/zfind/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "zfind";
    maintainers = with lib.maintainers; [ eeedean ];
  };
}
