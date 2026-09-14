{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  nose2,
  typing-extensions,
  setuptools,
  uv-build,
}:
let
  /*
    > ERROR Unmet dependencies (checked against /nix/store/3n4qphl9s728sz8frmpqqrv9b1m87g68-python3-3.14.7/bin/python3.14):
         >       uv_build==0.8.22
         >                wanted: ==0.8.22
         >                found: 0.11.28
  */
  uv-build-8 = uv-build.overrideAttrs (oldAttrs: rec {
    version = "0.8.22";
    src = fetchFromGitHub {
      owner = "astral-sh";
      repo = "uv";
      tag = version;
      hash = "sha256-7/WOjsyfkDTZLNJY0+rNdRUmMabJsSFvKi2yh/WqViQ=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit version src;
      pname = "uv-build";
      hash = "sha256-RubSyxQjWlkoHMItYLjiyJ5Whz3oMXgioqbuewi1fcM=";
    };

  });
in
buildPythonPackage (finalAttrs: {
  pname = "adaptix";
  version = "3.0.0b12";
  pyproject = true;

  build-system = [
    setuptools
    uv-build-8
  ];

  src = fetchFromGitHub {
    owner = "reagento";
    repo = "adaptix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-daW0yRweGf33EsiSOusKWOB8bw0kbSkWfyMuKUZet5s=";
  };

  nativeCheckInputs = [ nose2 ];

  checkInputs = [ typing-extensions ];

  pythonImportsCheck = [ "adaptix" ];

  meta = {
    description = "Modern way to convert python dataclasses or other objects to and from more common types like dicts or json-like structures";
    homepage = "https://github.com/reagento/adaptix";
    changelog = "https://github.com/reagento/adaptix/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
