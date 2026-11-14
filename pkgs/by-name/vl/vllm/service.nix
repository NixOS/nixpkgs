# Non-module dependencies (`importApply`)
{ }:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (builtins) toJSON;
  inherit (lib)
    maintainers
    types
    mkOption
    mkIf
    optionalAttrs
    getExe'
    ;
  cfg = config.vllm;
in
{
  _class = "service";

  options.vllm = {
    package = mkOption {
      type = types.package;
      description = "Package to use for vLLM.";
      defaultText = "The vLLM package that provided this module.";
    };

    settings = mkOption {
      type =
        with types;
        nullOr (submodule {
          freeformType = attrs;
          options = {
            host = mkOption {
              type = singleLineStr;
              default = "127.0.0.1";
              example = "0.0.0.0";
              description = "IP address on which the server should listen on.";
            };
            port = mkOption {
              type = port;
              default = 8000;
              example = 8080;
              description = "Port on which the server should listen on.";
            };
          };
        });
      default = null;
      example = {
        host = "0.0.0.0";
        port = 8080;
        enable-sleep-mode = true;
        model = "Foo/Bar";
        max-model-len = "252k";
        override-generation-config = {
          temperature = 0.6;
          top_k = 20;
          top_p = 0.95;
        };
        enable-auto-tool-choice = true;
        tool-call-parser = "bar";
        reasoning-parser = "baz";
        speculative-config = {
          method = "mtp";
          num_speculative_tokens = 3;
        };
      };
      description = ''
        Settings passed to vLLM as a YAML config file.

        See <https://docs.vllm.ai/en/latest/cli/serve> for the full list of options.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/vllm";
      description = ''
        Directory holding the vLLM state.

        When set to `/var/lib/vllm`, it is created by the unit's `StateDirectory`.
        Otherwise, you have to create the directory yourself, e.g. via systemd-tmpfiles.
      '';
    };

    cacheDir = mkOption {
      type = types.path;
      default = "/var/cache/vllm";
      description = ''
        Directory holding the cache of torchinductor and triton because their
        cache directories must be mounted without noexec.

        When set to `/var/cache/vllm`, it is created by the unit's `CacheDirectory`.
        Otherwise, you have to create the directory yourself, e.g. via systemd-tmpfiles.
      '';
    };
  };

  config = {
    process = {
      argv = [
        (getExe' cfg.package "vllm") # Handle python env as package
        "serve"
      ];
      flags."--config" = mkIf (cfg.settings != null) config.configData."config.yaml".path;
    };
    # YAML 1.2 is a superset of JSON
    configData."config.yaml" = {
      enable = cfg.settings != null;
      text = toJSON cfg.settings;
    };
  }
  // optionalAttrs (options ? systemd) {
    systemd.service = {
      description = "vLLM HTTP server";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # Many libraries like huggingface and AITER expect HOME to be available.
      # It's infeasible to set specific path variables for all of them
      environment = {
        HOME = cfg.dataDir;
        TORCHINDUCTOR_CACHE_DIR = "${cfg.cacheDir}/torchinductor";
        TRITON_CACHE_DIR = "${cfg.cacheDir}/triton";
      };

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 300;

        DynamicUser = true;
        CacheDirectory = mkIf (cfg.cacheDir == "/var/cache/vllm") "vllm";
        StateDirectory = mkIf (cfg.dataDir == "/var/lib/vllm") "vllm";

        # Most hardening settings copied verbatim from llama-cpp, except:
        # - ProcSubset must be "all" to fix missing /proc/meminfo
        # - RestrictAddressFamilies must be unset to fix no address family support
        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = [ "" ];
        # Fix torchinductor and triton cache dirs being noexec
        ExecPaths = [ cfg.cacheDir ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = false;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };
  };

  meta.maintainers = with maintainers; [ weathercold ];
}
