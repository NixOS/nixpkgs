{
  lib,
  elixir,
  fetchFromGitHub,
  fetchMixDeps,
  mixRelease,
  nix-update-script,

  # for tests
  beam27Packages,
  beam28Packages,
}:
# Based on ../elixir-ls/default.nix

let
  pname = "ex_doc";
  version = "0.40.1";
  src = fetchFromGitHub {
    owner = "elixir-lang";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-ZhsN2XI5WVy04ilNR/7NJo+C7F10lijsP+n3BGBNEkQ=";
  };
in
mixRelease {
  inherit
    pname
    version
    src
    elixir
    ;

  escriptBinName = "ex_doc";

  stripDebug = true;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    hash = "sha256-pMIm0lVMqkuiprp0XeVB+x4VTh+hQR3t8dk5OBmnIqA=";
  };

  passthru = {
    tests = {
      # ex_doc is the doc generation for OTP 27+, so let's make sure they build
      erlang_27 = beam27Packages.erlang;
      erlang_28 = beam28Packages.erlang;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elixir-lang/ex_doc";
    description = ''
      ExDoc produces HTML and EPUB documentation for Elixir projects
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "ex_doc";
    maintainers = with lib.maintainers; [ chiroptical ];
  };
}
