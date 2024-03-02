{lib, ...}:
let
  inherit (lib) options types;
in
options.mkOption {
  description = "A package in the manifest";
  example = (import ./release.nix {inherit lib;}).linux-x86_64;
  type = types.submodule {
    options = {
      relative_path = options.mkOption {
        description = "The relative path to the package";
        example = "cuda_cccl/linux-x86_64/cuda_cccl-linux-x86_64-11.5.62-archive.tar.xz";
        type = types.str;
      };
      sha256 = options.mkOption {
        description = "The sha256 hash of the package";
        example = "bbe633d6603d5a96a214dcb9f3f6f6fd2fa04d62e53694af97ae0c7afe0121b0";
        type = types.str;
      };
      md5 = options.mkOption {
        description = "The md5 hash of the package";
        example = "e5deef4f6cb71f14aac5be5d5745dafe";
        type = types.str;
      };
      size = options.mkOption {
        description = "The size of the package as a string";
        type = types.str;
        example = "960968";
      };
    };
  };
}
