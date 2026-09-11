let
  majorMinorToVersionMap = {
    "16" = "16.2.0";
    "15" = "15.3.0";
    "14" = "14.4.0";
    "13" = "13.5.0";
  };

  fromMajorMinor = majorMinorVersion: majorMinorToVersionMap."${majorMinorVersion}";

  srcHashForVersion =
    version:
    {
      # 3 digits: releases (14.2.0)
      # 4 digits: snapshots (14.2.1.20250322)
      "16.2.0" = "sha256-5nOOKVl/czJwcxqpBgDzf/3ARQed/CfsfoGSzIEIXD4=";
      "15.3.0" = "sha256-+lnBvu+JlfJ8TXHB3yJ1hxiTFdPm+v8btDBuYbDFMOs=";
      "14.4.0" = "sha256-dStvVnvqyDFZx3p2gLExa914Rzi/+anQcBEsCdqQ9tk=";
      "13.5.0" = "sha256-7D3wAV7QFBH5H5qc1bTaMHDrEiKwL630EzwwwJA5mFU=";
    }
    ."${version}";

in
{
  inherit fromMajorMinor;
  inherit srcHashForVersion;
  allMajorVersions = builtins.attrNames majorMinorToVersionMap;
}
