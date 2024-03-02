{options, ...}:
{
  options.cudnn.releases = options.generic.releases;
  # TODO(@connorbaker): Figure out how to add additional options to the
  # to the generic release.
  # {
  #   url = options.mkOption {
  #     description = "The URL to download the tarball from";
  #     type = types.str;
  #   };
  # }
}
