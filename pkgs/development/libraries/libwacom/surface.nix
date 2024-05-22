{ lib
, fetchFromGitHub
, libwacom
}:

let
  libwacom-surface = fetchFromGitHub {
    owner = "linux-surface";
    repo = "libwacom-surface";
    rev = "v2.7.0-1";
    hash = "sha256-LgJ8YFQQN05kyd6kxBakIIiGgZ9icW27xKK3Dz6TwLs=";
  };
in libwacom.overrideAttrs (old: {
  pname = "libwacom-surface";

  # These patches will not be included upstream:
  # https://github.com/linux-surface/libwacom/issues/2
  patches = old.patches or [ ] ++ map (p: "${libwacom-surface}/patches/v2/${p}") [
    "0001-Add-support-for-BUS_VIRTUAL.patch"
    "0002-Add-support-for-Intel-Management-Engine-bus.patch"
    "0003-data-Add-Microsoft-Surface-Pro-3.patch"
    "0004-data-Add-Microsoft-Surface-Pro-4.patch"
    "0005-data-Add-Microsoft-Surface-Pro-5.patch"
    "0006-data-Add-Microsoft-Surface-Pro-6.patch"
    "0007-data-Add-Microsoft-Surface-Pro-7.patch"
    "0008-data-Add-Microsoft-Surface-Book.patch"
    "0009-data-Add-Microsoft-Surface-Book-2-13.5.patch"
    "0010-data-Add-Microsoft-Surface-Book-2-15.patch"
    "0011-data-Add-Microsoft-Surface-Book-3-13.5.patch"
    "0012-data-Add-Microsoft-Surface-Book-3-15.patch"
  ];

  meta = old.meta // {
    homepage = "https://github.com/linux-surface/libwacom-surface";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
