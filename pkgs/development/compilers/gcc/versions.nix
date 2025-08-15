let
  majorMinorToVersionMap = {
    "15" = "15.2.0";
    "14" = "14.3.0";
    "13" = "13.4.0";
    "12" = "12.4.0";
    "11" = "11.5.0";
    "10" = "10.5.0";
    "9" = "9.5.0";
  };

  fromMajorMinor = majorMinorVersion: majorMinorToVersionMap."${majorMinorVersion}";

  # TODO(amjoseph): convert older hashes to SRI form
  srcHashForVersion =
    version:
    {
      # 3 digits: releases (14.2.0)
      # 4 digits: snapshots (14.2.1.20250322)
      "15.2.0" = "sha256-Q4/ZloJrDIJIWinaA6ctcdbjVBqD7HAt9Ccfb+Al0k4=";
      "14.3.0" = "sha256-4Nx3KXYlYxrI5Q+pL//v6Jmk63AlktpcMu8E4ik6yjo=";
      "13.4.0" = "sha256-nEzm27BAVo/cVFWIrAPFy8lajb8MeqSQFwhDr7WcqPU=";
      "12.4.0" = "sha256-cE9lJgTMvMsUvavzR4yVEciXiLEss7v/3tNzQZFqkXU=";
      "11.5.0" = "sha256-puIYaOrVRc+H8MAfhCduS1KB1nIJhZHByJYkHwk2NHg=";
      "10.5.0" = "sha256-JRCVQ/30bzl8NHtdi3osflaUpaUczkucbh6opxyjB8E=";
      "9.5.0" = "13ygjmd938m0wmy946pxdhz9i1wq7z4w10l6pvidak0xxxj9yxi7";
    }
    ."${version}";

in
{
  inherit fromMajorMinor;
  inherit srcHashForVersion;
  allMajorVersions = builtins.attrNames majorMinorToVersionMap;
}
