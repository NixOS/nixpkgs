{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zfind";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "laktak";
    repo = "zfind";
    rev = "v${version}";
    hash = "sha256-Nc7C0aauv/SChChAtyA089y6qTuaC9ClVz/u5QgJLPk=";
  };

  vendorHash = "sha256-WF5jeTeTK99MRNrIW80jYuyH60Rc/EVBW6owUCIyosE=";

  ldflags = [
    "-X"
    "main.appVersion=${version}"
  ];

  meta = with lib; {
    description = "CLI for file search with SQL like syntax.";
    longDescription = ''
      zfind allows you to search for files, including inside tar, zip, 7z and rar archives.
      It makes finding files easy with a filter syntax that is similar to an SQL-WHERE clause.
    '';
    homepage = "https://github.com/laktak/zfind";
    changelog = "https://github.com/laktak/zfind/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "zfind";
    maintainers = with maintainers; [ eeedean ];
  };
}
