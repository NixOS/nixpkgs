{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "yo";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "yeoman";
    repo = "yo";
    rev = "v${version}";
    hash = "sha256-0UkDANW58OZcEXGAgZ0Omob2AWyO6WszbN1nHLavdsM=";
  };

  npmDepsHash = "sha256-z0ZYrIk7FJXBsZJ72LiBWXJMI7FrCP/EjSTgqis+zIs=";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for running Yeoman generators";
    homepage = "https://github.com/yeoman/yo";
    license = lib.licenses.bsd2;
    mainProgram = "yo";
    maintainers = [ ];
  };
}
