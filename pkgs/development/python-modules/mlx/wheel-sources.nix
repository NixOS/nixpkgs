{
  version = "0.32.0";
  # Hash of the upstream source used for examples and benchmarks matching the wheel version.
  testSourceHash = "sha256-yHpTyRf9FOPbdyDWSM7b6VC72STnUpgCMLbDxLbdaqs=";

  mlx = {
    "3.13-aarch64-darwin" = {
      platform = "macosx_14_0_arm64";
      dist = "cp313";
      hash = "sha256-q7eG7h6WOHWb6CWDIi/H0JxWUO+QrSt8XafRkxqGdtw=";
    };
    "3.14-aarch64-darwin" = {
      platform = "macosx_14_0_arm64";
      dist = "cp314";
      hash = "sha256-LuebH4wsKjKa/JXs59zgvnmNQ/PedxpjcNK5+XArvZo=";
    };
  };

  mlx-metal = {
    "14" = {
      platform = "macosx_14_0_arm64";
      hash = "sha256-W2SyCsJLDEAfSJ3gHoIJ7cTTchJSAfGTFObznjhTIqo=";
    };
    "15" = {
      platform = "macosx_15_0_arm64";
      hash = "sha256-G9lKHOWwOgyJh3Gj51nwEkMAxqtRVRJ5BqHVCx8/zxk=";
    };
    # Includes NAX kernels for supported GPUs running macOS 26.2 or newer.
    "26" = {
      platform = "macosx_26_0_arm64";
      hash = "sha256-OvdqSY2EgE9mEZgASZ+dFD19/7CHig3Q18KEblhWX9c=";
    };
  };
}
