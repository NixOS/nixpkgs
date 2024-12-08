let
  majorMinorToVersionMap = {
    "14" = "14.2.0";
    "13" = "13.3.0";
    "12" = "12.4.0";
    "11" = "11.5.0";
    "10" = "10.5.0";
    "9"  =  "9.5.0";
  };

  fromMajorMinor = majorMinorVersion:
    majorMinorToVersionMap."${majorMinorVersion}";

  # TODO(amjoseph): convert older hashes to SRI form
  srcHashForVersion = version: {
    "14.2.0" = "sha256-p7Obxpy/niWCbFpgqyZHcAH3wI2FzsBLwOKcq+1vPMk=";
    "13.3.0" = "sha256-CEXpYhyVQ6E/SE6UWEpJ/8ASmXDpkUYkI1/B0GGgwIM=";
    "12.4.0" = "sha256-cE9lJgTMvMsUvavzR4yVEciXiLEss7v/3tNzQZFqkXU=";
    "11.5.0" = "sha256-puIYaOrVRc+H8MAfhCduS1KB1nIJhZHByJYkHwk2NHg=";
    "10.5.0" = "sha256-JRCVQ/30bzl8NHtdi3osflaUpaUczkucbh6opxyjB8E=";
    "9.5.0"  = "13ygjmd938m0wmy946pxdhz9i1wq7z4w10l6pvidak0xxxj9yxi7";
  }."${version}";

in {
  inherit fromMajorMinor;
  inherit srcHashForVersion;
  allMajorVersions = builtins.attrNames majorMinorToVersionMap;
}
