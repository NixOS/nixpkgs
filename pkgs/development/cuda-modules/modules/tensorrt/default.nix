{options, ...}:
{
  options.tensorrt.releases = options.generic.releases;
  # TODO(@connorbaker): Figure out how to add additional options to the
  # to the generic release.
  # {
  #   cudnnVersion = lib.options.mkOption {
  #     description = "The CUDNN version supported";
  #     type = types.nullOr majorMinorVersion;
  #   };
  #   filename = lib.options.mkOption {
  #     description = "The tarball name";
  #     type = types.str;
  #   };
  # }
}
