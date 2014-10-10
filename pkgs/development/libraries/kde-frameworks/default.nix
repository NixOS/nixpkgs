{ pkgs, autonix, stdenv
, qt53
}:

with autonix;
with stdenv.lib;

callAutoCollection ./. {

  manifestRules = [
    breakRecursion

    (renameInput "pythoninterp" "python")

    (userEnvPkgs [
      "shared_mime_info"
    ])

    (propagateInputs [
      "cmake"
      "gettext"
      "pkgconfig"
      "shared_mime_info"
    ])

    (nativeInputs [
      "cmake"
      "gettext"
      "kdoctools"
      "pkgconfig"
      "pythoninterp"
      "shared_mime_info"
    ])

    (mapInputNames (name: if hasPrefix "qt5" name then "qt5" else name))
    (renameInput "ecm" "extra-cmake-modules")
    (renameInput "openexr" "ilmbase")
    (renameInput "sharedmimeinfo" "shared_mime_info")

    (mapInputNames (name:
      if hasPrefix "kf5" name && name != "kf5"
        then "k" + removePrefix "kf5" name
      else name))

    (perPackage {
      extra-cmake-modules = filterInputsByName (n: !(hasPrefix "kf5" n));
    })
  ];

  scope = pkgs // { qt5 = qt53; };
}
