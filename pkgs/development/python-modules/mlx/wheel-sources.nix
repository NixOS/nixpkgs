{
  version = "0.31.2";
  # Hash of the upstream source used for examples and benchmarks matching the wheel version.
  testSourceHash = "sha256-0Oxacz61WGWZrpWw+fMQjEQfwOx1l1L2d0kWl54/LrQ=";

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
    "14" = {
      platform = "macosx_14_0_arm64";
      hash = "sha256-slOFvO4Y/BlAkiVbi1O5o9hInrZQ5ZFg8bV6rdB6otw=";
    };
    "15" = {
      platform = "macosx_15_0_arm64";
      hash = "sha256-6dTl/ObKEKh6DjiFl/mVGa1ZTQnmdHCLUxK9i9T1mX0=";
    };
    # Includes NAX kernels for supported GPUs running macOS 26.2 or newer.
    "26" = {
      platform = "macosx_26_0_arm64";
      hash = "sha256-hP+2DuUD8D62hPX7Fo1c/zHioWt/J8FzHq92Yr1um0Y=";
    };
  };
}
