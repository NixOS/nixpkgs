{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ojs,
  gen_js_api,
}:

buildDunePackage (finalAttrs: {
  pname = "jsonoo";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mlantas";
    repo = "jsonoo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BElpGAAIiC6Y7TY7yTW60Er5YJVwbn179+vdOZB4jNY=";
  };

  nativeBuildInputs = [
    gen_js_api
  ];

  propagatedBuildInputs = [
    ojs
    gen_js_api
  ];

  # Depends on unpackaged webtest
  doCheck = false;

  meta = {
    description = "JSON library for Js_of_ocaml";
    homepage = "https://github.com/mlantas/jsonoo";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
