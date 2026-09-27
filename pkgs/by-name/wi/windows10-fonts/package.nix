{
  lib,
  fetchurl,
  windows11-fonts,
}:
(windows11-fonts.override {
  languages = import ./languages.nix;
  os = "Microsoft Windows 10";
}).overrideAttrs
  (
    _: prev: {
      pname = "windows10-fonts";
      version = "10.0.19045.2006-1";
      src = fetchurl {
        url = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso";
        hash = "sha256-bqeKy1+ojCwJdfZ2zEbKWTtDUYPIFbinxWHlbOkaajk=";
        # Don't ever cache this
        meta.license = lib.licenses.unfree;
      };
    }
  )
