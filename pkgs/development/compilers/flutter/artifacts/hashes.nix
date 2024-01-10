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

# Schema:
# ${flutterVersion}.${targetPlatform}.${hostPlatform}
#
# aarch64-darwin as a host is not yet supported.
# https://github.com/flutter/flutter/issues/60118
{
  "3.13.8" = {
    android = {
      x86_64-linux = "sha256-Uc36aBq8wQo2aEvjAPOoixZElWOE/GNRm2GUfhbwT3Y=";
      aarch64-linux = "sha256-Uc36aBq8wQo2aEvjAPOoixZElWOE/GNRm2GUfhbwT3Y=";
      x86_64-darwin = "sha256-v/6/GTj7732fEOIgSaoM00yaw2qNwOMuvbuoCvii7vQ=";
    };
    fuchsia = {
      x86_64-linux = "sha256-eu0BERdz53CkSexbpu3KA7O6Q4g0s9SGD3t1Snsk3Fk=";
      aarch64-linux = "sha256-eu0BERdz53CkSexbpu3KA7O6Q4g0s9SGD3t1Snsk3Fk=";
      x86_64-darwin = "sha256-eu0BERdz53CkSexbpu3KA7O6Q4g0s9SGD3t1Snsk3Fk=";
    };
    ios = {
      x86_64-linux = "sha256-QwkeGnutTVsm682CqxRtEd9rKUvN7zlAJcqkvAQYwao=";
      aarch64-linux = "sha256-QwkeGnutTVsm682CqxRtEd9rKUvN7zlAJcqkvAQYwao=";
      x86_64-darwin = "sha256-QwkeGnutTVsm682CqxRtEd9rKUvN7zlAJcqkvAQYwao=";
    };
    linux = {
      x86_64-linux = "sha256-0gIOwux3YBdmcXgwICr8dpftj1CauaBUX8Rt5GG0WSs=";
      aarch64-linux = "sha256-drGHsuJoOCLqrhVrXczqJRCOtpeWVlqdWW0OSMS/l5M=";
      x86_64-darwin = "sha256-0gIOwux3YBdmcXgwICr8dpftj1CauaBUX8Rt5GG0WSs=";
    };
    macos = {
      x86_64-linux = "sha256-9WqCJQ37mcGc5tzfqQoY5CqHWHGTizjXf9p73bdnNWc=";
      aarch64-linux = "sha256-9WqCJQ37mcGc5tzfqQoY5CqHWHGTizjXf9p73bdnNWc=";
      x86_64-darwin = "sha256-9WqCJQ37mcGc5tzfqQoY5CqHWHGTizjXf9p73bdnNWc=";
    };
    universal = {
      x86_64-linux = "sha256-wATt1UPjo/fh7RFO1vvcUAdo0dMAaaOUIuzYodsM0v0=";
      aarch64-linux = "sha256-Z9bszNaIpCccG7OfvE5WFsw36dITiyCQAZ6p29+Yq68=";
      x86_64-darwin = "sha256-qN5bAXRfQ78TWF3FLBIxWzUB5y5OrZVQTEilY5J/+2k=";
    };
    web = {
      x86_64-linux = "sha256-DVXJOOFxv7tKt3d0NaYMexkphEcr7+gDFV67I6iAYa0=";
      aarch64-linux = "sha256-DVXJOOFxv7tKt3d0NaYMexkphEcr7+gDFV67I6iAYa0=";
      x86_64-darwin = "sha256-DVXJOOFxv7tKt3d0NaYMexkphEcr7+gDFV67I6iAYa0=";
    };
    windows = {
      x86_64-linux = "sha256-s8fJtwQkuZaGXr6vrPiKfpwP/NfewbETwyp9ERGqHYI=";
      aarch64-linux = "sha256-s8fJtwQkuZaGXr6vrPiKfpwP/NfewbETwyp9ERGqHYI=";
      x86_64-darwin = "sha256-s8fJtwQkuZaGXr6vrPiKfpwP/NfewbETwyp9ERGqHYI=";
    };
  };
}
