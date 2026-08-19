{
  config,
}:

# Accept the license in the test suite.
config.android_sdk.accept_license or (
  builtins.getEnv "NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE" == "1"
  || builtins.getEnv "UPDATE_NIX_ATTR_PATH" == "androidenv.test-suite"
)
