{
  version = "0.32.2";
  # Hash of the upstream source used for examples and benchmarks matching the wheel version.
  testSourceHash = "sha256-pAQZ1RJq9Mb66qXMdZUt3znNKY+bhpxYckY708i0CmY=";

  mlx = {
    "3.13-aarch64-darwin" = {
      platform = "macosx_14_0_arm64";
      dist = "cp313";
      hash = "sha256-ZdPSm2YEXtjdLY5DfIdw3jJYQ8Nk97fDjNiukKfuyFQ=";
    };
    "3.14-aarch64-darwin" = {
      platform = "macosx_14_0_arm64";
      dist = "cp314";
      hash = "sha256-yZ47ZFG7SlUHHPGVlPVkQ1vYjedwCPN35hGkCou/syg=";
    };
  };

  mlx-metal = {
    "14" = {
      platform = "macosx_14_0_arm64";
      hash = "sha256-OCX/83nbwQfdNBPlZKBsrqokgZkQ7EnAQ55FTAahubg=";
    };
    "15" = {
      platform = "macosx_15_0_arm64";
      hash = "sha256-VaNpJQ0iCyzxAhOoeirBsaQgYIxbNbHfTnFHrI4y8SE=";
    };
    # Includes NAX kernels for supported GPUs running macOS 26.2 or newer.
    "26" = {
      platform = "macosx_26_0_arm64";
      hash = "sha256-5qvqyaxSZYMMnBVBtvlum+N6hcJEZ2OkatRmxjo4N6s=";
    };
  };
}
