{
  buildPythonPackage,
  fetchPypi,
  lib,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "minify-html";
  version = "0.15.0";

  pyproject = true;

  # Fetching from Pypi, because there is no Cargo.lock in the GitHub repo.
  src = fetchPypi {
    inherit version;
    pname = "minify_html";
    hash = "sha256-z0w2tvmvOwkBvSoKKds7CcDN8MONPd4o5oNbzg9gXTc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-f93gKKQRkjxQJ49EK/0UI+BzFEa6iSfDX/0gNysSDmc=";
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
    maintainers = lib.teams.apm.members;
  };
}
