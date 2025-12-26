{
  buildPythonPackage,
  fetchPypi,
  lib,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "minify-html";
  version = "0.18.1";

  pyproject = true;

  # Fetching from Pypi, because there is no Cargo.lock in the GitHub repo.
  src = fetchPypi {
    inherit version;
    pname = "minify_html";
    hash = "sha256-Q5mFMO9TdwHwA6jpCLdW147/MDyGsEGpWFXikFGLp5w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-K0m+rM0dcosAOl5jYdh9CSRrL/Vuk1ATWHPQJbLxvRw=";
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
