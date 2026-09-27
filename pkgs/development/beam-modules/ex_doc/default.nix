{
  lib,
  fetchFromGitHub,
  fetchMixDeps,
  mixRelease,
  nix-update-script,
}:

mixRelease (finalAttrs: {
  pname = "ex_doc";
  version = "0.40.4";
  src = fetchFromGitHub {
    owner = "elixir-lang";
    repo = "${finalAttrs.pname}";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wDdBjq62TX8m50LeszMx4f8nlUeMgElpKZ3imHNq7Hs=";
  };

  escriptBinName = "ex_doc";

  stripDebug = true;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${finalAttrs.pname}";
    inherit (finalAttrs) src version;
    hash = "sha256-gjvvNG8LUFG5YouwFygbXeWUzlxpESAPZWzqXyS6vBw=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elixir-lang/ex_doc";
    changelog = "https://github.com/elixir-lang/ex_doc/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = ''
      ExDoc produces HTML and EPUB documentation for Elixir projects
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "ex_doc";
    maintainers = with lib.maintainers; [ chiroptical ];
  };
})
