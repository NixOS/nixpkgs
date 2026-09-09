{
  lib,
  version,
  fetchpatch,
}:

# Backports for LLVM support.
#
# These primarily focus on backporting patches that are relevant to
# supporting newer LLVM versions, rather than aiming to backport every
# LLVM backend bug fix or improvement from newer GHC releases.
#
# Potentially of interest for cross‐compiling GHC 9.4.8 to LoongArch64:
#
# * <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/9292>
# * <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/13620>

[ ]

++ lib.optionals (lib.versionOlder version "9.6") [
  # <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/9857>
  (fetchpatch {
    name = "ghc-9.4-llvm-support-15.patch";
    url = "https://gitlab.haskell.org/ghc/ghc/-/commit/0cc16aaf89d7dc3963764b7193ceac73e4e3329b.patch";
    hash = "sha256-G0gqrj5iPuQ5JuC2+d151yka72XZMbrqMWPZd4EuT04=";
  })

  # <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/13763>
  ./ghc-9.4-llvm-fix-version-detection.patch
]

++ lib.optionals (lib.versionOlder version "9.8") [
  (
    # The upstream backport of !13763 in 9.6.7 removed an unused import
    # that is required by the next series.
    if lib.versionOlder version "9.6" then null else ./ghc-9.6-llvm-restore-import.patch
  )
]

++ lib.optionals (lib.versionOlder version "9.10") [
  # <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/11124>
  (
    if lib.versionOlder version "9.8" then
      ./ghc-9.4-llvm-add-metadata-exports.patch
    else
      fetchpatch {
        name = "ghc-9.8-llvm-add-metadata-exports.patch";
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/fcfc1777c22ad47613256c3c5e7304cfd29bc761.patch";
        hash = "sha256-9rpyeH8TUVeKoW4PA6qn7DG2+P9MhBCywmbi1O/NsTQ=";
      }
  )
  (
    if lib.versionOlder version "9.8" then
      ./ghc-9.4-llvm-allow-llvmlits-in-metaexprs.patch
    else
      fetchpatch {
        name = "ghc-9.8-llvm-allow-llvmlits-in-metaexprs.patch";
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/5880fff6d353a14785c457999fded5a7100c9514.patch";
        hash = "sha256-NDMGNc0PYpWJUW+nI2YvMsBOWRIfNix4oWHQZAIxrVY=";
      }
  )
  (
    # `GHC.Driver.DynFlags` was not split out until 9.8, so this can be
    # omitted with no functional effect on the rest of the series on
    # earlier versions.
    if lib.versionOlder version "9.8" then
      null
    else
      fetchpatch {
        name = "ghc-9.8-move-feature-predicates-to-dynflags.patch";
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/86ce92a2f81a04aa980da2891d0e300cb3cb7efd.patch";
        hash = "sha256-SzJgzq4b5wAMPz+/QSa67iSOxB2enqejvV0lsF0+9L8=";
      }
  )
  (fetchpatch {
    name = "ghc-9.4-llvm-add-module-flag-metadata-infra.patch";
    url = "https://gitlab.haskell.org/ghc/ghc/-/commit/a6a3874276ced1b037365c059dcd0a758e813a5b.patch";
    hash = "sha256-tAYDRNXmpp5cZtyONpO8vlsDmnNEBbh4J3oSCy/uWWc=";
  })
  (
    if lib.versionOlder version "9.8" then
      ./ghc-9.4-llvm-fix-stack-alignment.patch
    else
      fetchpatch {
        name = "ghc-9.8-llvm-fix-stack-alignment.patch";
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/e9af2cf3f16ab60b5c79ed91df95359b11784df6.patch";
        hash = "sha256-RmYwFN3c3AgJxF9KXWQLdwOgugzepCW1wcTdJX1h0C4=";
      }
  )

  # <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/8999>
  (
    if lib.versionOlder version "9.6" then
      ./ghc-9.4-llvm-use-new-pass-manager.patch
    else if lib.versionOlder version "9.8" then
      ./ghc-9.6-llvm-use-new-pass-manager.patch
    else
      ./ghc-9.8-llvm-use-new-pass-manager.patch
  )
]

++ lib.optionals (lib.versionOlder version "9.12") [
  # <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/12726>
  (fetchpatch {
    name = "ghc-9.4-llvm-support-16-17-18.patch";
    url = "https://gitlab.haskell.org/ghc/ghc/-/commit/ae170155e82f1e5f78882f7a682d02a8e46a5823.patch";
    hash = "sha256-U1znWqXZTORmAg480p5TjTL53T2Zn+1+9Fnk2V1Drfs=";
  })

  # <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/13311>
  (fetchpatch {
    name = "ghc-9.4-llvm-support-19.patch";
    url = "https://gitlab.haskell.org/ghc/ghc/-/commit/36bbb167f354a2fbc6c4842755f2b1e374e3580e.patch";
    excludes = [ ".gitlab-ci.yml" ];
    hash = "sha256-v8T/FtriDPbibcIDZmU2yotBoDVo+wU2+gw+CCdQlm0=";
  })
]

++ lib.optionals (lib.versionOlder version "9.14") [
  # <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/14600>
  (fetchpatch {
    name = "ghc-9.4-llvm-support-20.patch";
    url = "https://gitlab.haskell.org/ghc/ghc/-/commit/ca03226db2db2696460bfcb8035dd3268d546706.patch";
    hash = "sha256-7cO049DQtJHUAhwPujoFO+zQtXsMg6VFTHtMDwenrKs=";
  })
]
