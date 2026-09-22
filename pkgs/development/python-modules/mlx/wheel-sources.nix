{
  version = "0.31.2";

  mlx = {
    "3.13-aarch64-darwin" = {
      platform = "macosx_14_0_arm64";
      dist = "cp313";
      hash = "sha256-Gz+w3alVsNVSzle91vQrMwmrIbBn5AWH1oSEQ9MH6R8=";
    };
    "3.14-aarch64-darwin" = {
      platform = "macosx_14_0_arm64";
      dist = "cp314";
      hash = "sha256-oTyc4jw97vaqWgkxXnlT4aXcMR6FH6Fvx0yB+yUJwLk=";
    };
  };

  mlx-metal = {
    platform = "macosx_14_0_arm64";
    hash = "sha256-slOFvO4Y/BlAkiVbi1O5o9hInrZQ5ZFg8bV6rdB6otw=";
  };
}
