{
  buildPythonPackage,
  fetchPypi,
  lib,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "minify-html";
  version = "0.18.0";

  pyproject = true;

  # Fetching from Pypi, because there is no Cargo.lock in the GitHub repo.
  src = fetchPypi {
    inherit version;
    pname = "minify_html";
    hash = "sha256-B6Tip6E+WXgHRmV1rY4GNXc2q7fX+80VO/Njk/7a48E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-oOhE55doSjCnGx1uyOP4FGjf6tPP3O20gPQSab7lBfM=";
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
