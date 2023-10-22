# NOTICE: When updating these hashes, make sure that no additional platforms
# have been added to the `flutter precache` CLI. If any have, they may be
# included in every derivation, unless they are also added to the platform list
# in fetch-artifacts.nix.
#
# The known arguments are as follows:
# $ flutter precache --help --verbose
# Usage: flutter precache [arguments]
# -h, --help                              Print this usage information.
# -a, --all-platforms                     Precache artifacts for all host platforms.
# -f, --force                             Force re-downloading of artifacts.
#     --[no-]android                      Precache artifacts for Android development.
#     --[no-]android_gen_snapshot         Precache gen_snapshot for Android development.
#     --[no-]android_maven                Precache Gradle dependencies for Android development.
#     --[no-]android_internal_build       Precache dependencies for internal Android development.
#     --[no-]ios                          Precache artifacts for iOS development.
#     --[no-]web                          Precache artifacts for web development.
#     --[no-]linux                        Precache artifacts for Linux desktop development.
#     --[no-]windows                      Precache artifacts for Windows desktop development.
#     --[no-]macos                        Precache artifacts for macOS desktop development.
#     --[no-]fuchsia                      Precache artifacts for Fuchsia development.
#     --[no-]universal                    Precache artifacts required for any development platform.
#                                         (defaults to on)
#     --[no-]flutter_runner               Precache the flutter runner artifacts.
#     --[no-]use-unsigned-mac-binaries    Precache the unsigned macOS binaries when available.

{
  "3.13.8" = {
    android = "sha256-Uc36aBq8wQo2aEvjAPOoixZElWOE/GNRm2GUfhbwT3Y=";
    fuchsia = "sha256-eu0BERdz53CkSexbpu3KA7O6Q4g0s9SGD3t1Snsk3Fk=";
    ios = "sha256-QwkeGnutTVsm682CqxRtEd9rKUvN7zlAJcqkvAQYwao=";
    linux = "sha256-0gIOwux3YBdmcXgwICr8dpftj1CauaBUX8Rt5GG0WSs=";
    macos = "sha256-9WqCJQ37mcGc5tzfqQoY5CqHWHGTizjXf9p73bdnNWc=";
    universal = "sha256-wATt1UPjo/fh7RFO1vvcUAdo0dMAaaOUIuzYodsM0v0=";
    web = "sha256-DVXJOOFxv7tKt3d0NaYMexkphEcr7+gDFV67I6iAYa0=";
    windows = "sha256-s8fJtwQkuZaGXr6vrPiKfpwP/NfewbETwyp9ERGqHYI=";
  };
}
