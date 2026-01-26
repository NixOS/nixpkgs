{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme";
  version = "0.3";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "bensmrs";
    repo = "gendarme";
    tag = finalAttrs.version;
    hash = "sha256-GWWAbYevd74YYRpyUjEI4rtzuXGZPp4Wa4uUqD6D7l8=";
  };

  meta = {
    description = "Marshalling library for OCaml";
    homepage = "https://github.com/bensmrs/gendarme";
    changelog = "https://github.com/bensmrs/gendarme/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
})
