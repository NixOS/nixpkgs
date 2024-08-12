{
  lib,
  config,
  stdenv,
  ...
}:

{
  options = {
    headlessDeps = lib.mkOption {
      default = true;
      description = "";
    };
    fullDeps = lib.mkOption {
      default = false;
      description = "";
    };
    alsa = lib.mkOption {
      default = config.headlessDeps && stdenv.isLinux;
      description = "Alsa in/output support";
    };
    aom = lib.mkOption {
      default = config.fullDeps;
      description = "AV1 reference encoder";
    };
  };
}
