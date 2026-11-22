{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thokr";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "thokr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ouirz8ogB15iDY3O1KpRo8HA1p/OQsT9UvZjfq2Soc0=";
  };

  cargoHash = "sha256-23e/YGz/If3zWnp925Ys3dnGYHJBQfdWKTbzCjVJa4E=";

  meta = {
    description = "Typing tui with visualized results and historical logging";
    homepage = "https://github.com/jrnxf/thokr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "thokr";
  };
})
