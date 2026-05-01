{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.46.1";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-Ob3bzaUrHfDaRy25eWmE3YEtZxhZGYp6TEMtDWbzgQs=";
  };

  npmDepsHash = "sha256-24z5w43ciXydl14XwC0XZ5kZX9HoXFQyWHYntQXMHy0=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
