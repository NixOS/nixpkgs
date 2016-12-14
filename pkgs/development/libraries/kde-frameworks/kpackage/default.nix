{ kdeFramework, fetchurl, lib, copyPathsToStore
, ecm
, karchive
, kconfig
, kcoreaddons
, kdoctools
, ki18n
}:

kdeFramework {
  name = "kpackage";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [ karchive kconfig kcoreaddons ki18n ];
  patches =
    copyPathsToStore (lib.readPathsFromFile ./. ./series)
    ++ [
      (fetchurl {
        url = "https://cgit.kde.org/kpackage.git/patch/?id=26e59d58438cc777873a6afc7817418ec735aaa3";
        sha256 = "05ad3awdq8cz1bmnhnf1lapvm70z5qc8sbdzrcgxlka7wzdbm5lw";
        name = "fix-cmake-failure-package-id-collision.patch";
      })
      (fetchurl {
        url = "https://cgit.kde.org/kpackage.git/patch/?id=17915200921836d61266ad93dd6c3b87db1dc9e4";
        sha256 = "07irfx297lf39cyrv10i3q4z04fr8msm6pcp8mcwvss4gih05b74";
        name = "fix-cmake-failure-package-id-collision.patch";
      })
    ];
}
