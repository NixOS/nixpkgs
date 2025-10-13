{
  buildPythonPackage,
  fetchPypi,
  lib,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "minify-html";
  version = "0.16.4";

  pyproject = true;

  # Fetching from Pypi, because there is no Cargo.lock in the GitHub repo.
  src = fetchPypi {
    inherit version;
    pname = "minify_html";
    hash = "sha256-3UjI/5ZhoQNHYkAqdBGzFohnqXP4/Hiwn2foGCC2TSI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-NLPei6ajR55mLyFhsjzUpXB/TsqqeDvP8yKE74t0ufk=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [ "minify_html" ];

  meta = {
    description = "Extremely fast and smart HTML + JS + CSS minifier";
    homepage = "https://github.com/wilsonzlin/minify-html/tree/master/minify-html-python";
    changelog = "https://github.com/wilsonzlin/minify-html/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.apm ];
  };
}
