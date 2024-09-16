{
  e2fsprogs,
  fetchpatch,
  fetchzip,
  gst_all_1,
  kdePackages,
  lib,
  libtiff,
  qt5 ? null,
  qt6 ? null,
  rdma-core,
  ucx,
  utils,
}:
let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) optionals;
  inherit (lib.strings) versionOlder versionAtLeast;
  # Most of this is taken directly from
  # https://github.com/NixOS/nixpkgs/blob/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b/pkgs/development/libraries/libtiff/default.nix
  libtiff_4_5 = libtiff.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "4.4.0";
      src = fetchzip {
        url = "https://download.osgeo.org/libtiff/tiff-${finalAttrs.version}.tar.gz";
        hash = "sha256-NiqxTgfXIvUsVMu9nTJULVulfcFm+Z2IBMc6mNgwnsY=";
      };
      patches = [
        # FreeImage needs this patch
        (fetchpatch {
          name = "headers.patch";
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/release-22.11/pkgs/development/libraries/libtiff/headers.patch";
          hash = "sha256-+eaPCdWUyGC6rfEd54/8PqqGZ4hg8GpH75/NZgTKTt4=";
        })
        # libc++abi 11 has an `#include <version>`, this picks up files name
        # `version` in the project's include paths
        (fetchpatch {
          name = "rename-version.patch";
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/release-22.11/pkgs/development/libraries/libtiff/rename-version.patch";
          hash = "sha256-ykefUIyTqcAWX9b/CtqPsd82AsUFZZGhiL+9UmEcvU8=";
        })
        (fetchpatch {
          name = "CVE-2022-34526.patch";
          url = "https://gitlab.com/libtiff/libtiff/-/commit/275735d0354e39c0ac1dc3c0db2120d6f31d1990.patch";
          hash = "sha256-faKsdJjvQwNdkAKjYm4vubvZvnULt9zz4l53zBFr67s=";
        })
        (fetchpatch {
          name = "CVE-2022-2953.patch";
          url = "https://gitlab.com/libtiff/libtiff/-/commit/48d6ece8389b01129e7d357f0985c8f938ce3da3.patch";
          hash = "sha256-h9hulV+dnsUt/2Rsk4C1AKdULkvweM2ypIJXYQ3BqQU=";
        })
        (fetchpatch {
          name = "CVE-2022-3626.CVE-2022-3627.CVE-2022-3597.patch";
          url = "https://gitlab.com/libtiff/libtiff/-/commit/236b7191f04c60d09ee836ae13b50f812c841047.patch";
          excludes = [ "doc/tools/tiffcrop.rst" ];
          hash = "sha256-L2EMmmfMM4oEYeLapO93wvNS+HlO0yXsKxijXH+Wuas=";
        })
        (fetchpatch {
          name = "CVE-2022-3598.CVE-2022-3570.patch";
          url = "https://gitlab.com/libtiff/libtiff/-/commit/cfbb883bf6ea7bedcb04177cc4e52d304522fdff.patch";
          hash = "sha256-SLq2+JaDEUOPZ5mY4GPB6uwhQOG5cD4qyL5o9i8CVVs=";
        })
        (fetchpatch {
          name = "CVE-2022-3970.patch";
          url = "https://gitlab.com/libtiff/libtiff/-/commit/227500897dfb07fb7d27f7aa570050e62617e3be.patch";
          hash = "sha256-pgItgS+UhMjoSjkDJH5y7iGFZ+yxWKqlL7BdT2mFcH0=";
        })
        (fetchpatch {
          name = "4.4.0-CVE-2022-48281.patch";
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/release-22.11/pkgs/development/libraries/libtiff/4.4.0-CVE-2022-48281.patch";
          hash = "sha256-i/Gw8MvqlOwy2CupJrX7Ec1yS9xg+19CM9kKlxvvvYE=";
        })
        (fetchpatch {
          name = "4.4.0-CVE-2023-0800.CVE-2023-0801.CVE-2023-0802.CVE-2023-0803.CVE-2023-0804.patch";
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/release-22.11/pkgs/development/libraries/libtiff/4.4.0-CVE-2023-0800.CVE-2023-0801.CVE-2023-0802.CVE-2023-0803.CVE-2023-0804.patch";
          hash = "sha256-yKMI8AJALEV/qjJk5MhIOj+x2nHMzDvnrroWRjTcqP4=";
        })
        (fetchpatch {
          name = "4.4.0-CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.prerequisite-0.patch";
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/release-22.11/pkgs/development/libraries/libtiff/4.4.0-CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.prerequisite-0.patch";
          hash = "sha256-+MHoxuzJj7ADjKz4zl4YO+e1IdzphXa451h+sRZ7gys=";
        })
        (fetchpatch {
          name = "4.4.0-CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.prerequisite-1.patch";
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/release-22.11/pkgs/development/libraries/libtiff/4.4.0-CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.prerequisite-1.patch";
          hash = "sha256-+UHvo03zlmwxu1s5oRCK9SudgjcjV/iaMKW4SY/wy4E=";
        })
        (fetchpatch {
          name = "4.4.0-CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.patch";
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/release-22.11/pkgs/development/libraries/libtiff/4.4.0-CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.patch";
          hash = "sha256-tMZ/ci2am9XNmD889XdjNnBUKNiN3/toMP1+QWQx+wE=";
        })
        (fetchpatch {
          name = "CVE-2022-4645.patch";
          url = "https://gitlab.com/libtiff/libtiff/-/commit/f00484b9519df933723deb38fff943dc291a793d.patch";
          sha256 = "sha256-sFVi5BY/L8WisrtTThkux1Gw2x0UrurnSlv4KkEvw3w=";
        })
      ];
    }
  );
in
finalAttrs: prevAttrs:
let
  inherit (finalAttrs) version;
  qt = if versionOlder version "2022.2.0" then qt5 else qt6;
  inherit (qt) wrapQtAppsHook qtwebview;
  qtwayland = lib.getBin qt.qtwayland;
in
{
  allowFHSReferences = true;
  nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ wrapQtAppsHook ];
  buildInputs =
    prevAttrs.buildInputs
    ++ [ qtwebview ]
    ++ optionals (versionAtLeast version "2022.4") [
      e2fsprogs
      libtiff_4_5
      qtwayland
      rdma-core
      ucx
    ]
    ++ optionals (versionAtLeast version "2023.1") [ gst_all_1.gst-plugins-base ];
  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions (
      optionalAttrs (versionOlder version "2022.2.0") { inherit qt5; }
      // optionalAttrs (versionAtLeast version "2022.2.0") { inherit qt6; }
    );
}
