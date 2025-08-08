let
  majorMinorToVersionMap = {
    "15" = "15.2.0";
    "14" = "14.3.0";
    "13" = "13.4.0";
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
    }
    ."${version}";

in
{
  inherit fromMajorMinor;
  inherit srcHashForVersion;
  allMajorVersions = builtins.attrNames majorMinorToVersionMap;
}
