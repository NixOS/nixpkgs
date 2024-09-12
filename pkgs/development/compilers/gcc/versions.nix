let
  majorMinorToVersionMap = {
    "14" = "14.2.0";
    "13" = "13.3.0";
    "12" = "12.4.0";
    "11" = "11.5.0";
    "10" = "10.5.0";
    "9"  =  "9.5.0";
    "8"  =  "8.5.0";
    "7"  =  "7.5.0";
    "6"  =  "6.5.0";
    "4.9"=  "4.9.4";
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
    "8.5.0"  = "0l7d4m9jx124xsk6xardchgy2k5j5l2b15q322k31f0va4d8826k";
    "7.5.0"  = "0qg6kqc5l72hpnj4vr6l0p69qav0rh4anlkk3y55540zy3klc6dq";
    "6.5.0"  = "0i89fksfp6wr1xg9l8296aslcymv2idn60ip31wr9s4pwin7kwby";
    "4.9.4"  = "14l06m7nvcvb0igkbip58x59w3nq6315k6jcz3wr9ch1rn9d44bc";
  }."${version}";

in {
  inherit fromMajorMinor;
  inherit srcHashForVersion;
  allMajorVersions = builtins.attrNames majorMinorToVersionMap;
}
