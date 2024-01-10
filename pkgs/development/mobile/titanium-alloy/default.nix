{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "alloy";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "tidev";
    repo = "alloy";
    rev = version;
    hash = "sha256-OQfZNmrR+aPS/s+h1Wy2zGqe6djD0PCltFh5KtdfDWg=";
  };

  npmDepsHash = "sha256-Rd4UpflYD90QYwBof91WUO6XwNgsLuXITH35G0lspz0=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/tidev/alloy/blob/${src.rev}/CHANGELOG.md";
    description = "MVC framework for the Appcelerator Titanium SDK";
    homepage = "https://github.com/tidev/alloy";
    license = lib.licenses.asl20;
    mainProgram = "alloy";
    maintainers = with lib.maintainers; [ ];
  };
}
