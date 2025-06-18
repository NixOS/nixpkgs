{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  erlang,
}:

let
  shell =
    drv:
    stdenv.mkDerivation {
      name = "interactive-shell-${drv.name}";
      buildInputs = [ drv ];
    };

  pkg =
    self:
    stdenv.mkDerivation {
      pname = "webdriver";
      version = "0.pre+unstable=2015-02-08";

      src = fetchFromGitHub {
        owner = "Quviq";
        repo = "webdrv";
        rev = "7ceaf1f67d834e841ca0133b4bf899a9fa2db6bb";
        sha256 = "1pq6pmlr6xb4hv2fvmlrvzd8c70kdcidlgjv4p8n9pwvkif0cb87";
      };

      setupHook = writeText "setupHook.sh" ''
        addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
      '';

      buildInputs = [ erlang ];

      installFlags = [ "PREFIX=$(out)/lib/erlang/lib" ];

      meta = {
        description = "WebDriver implementation in Erlang";
        license = lib.licenses.mit;
        homepage = "https://github.com/Quviq/webdrv";
        maintainers = with lib.maintainers; [ ericbmerritt ];
      };

      passthru = {
        env = shell self;
      };

    };
in
lib.fix pkg
