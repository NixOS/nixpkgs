{ pkgs, autonix, stdenv, callAutoCollection }:

with autonix.collection;
with stdenv.lib;

callAutoCollection ./. {

  manifestRules = [
    breakRecursion

    (substInputs {
      cmake = {
        native = true;
        propagated = true;
      };

      ecm = {
        name = "extra-cmake-modules";
        native = true;
        propagated = true;
      };

      gif = { name = "giflib"; };

      kdoctools = { native = true; };

      # Removing the "kf5" prefix of the input names gives an extra "k"
      kattica = { name = "attica"; };
      kkio = { name = "kio"; };
      kplasma = { name = "plasma-framework"; };
      ksolid = { name = "solid"; };
      ksonnet = { name = "sonnet"; };
      kthreadweaver = { name = "threadweaver"; };
      kwebkit = { name = "kdewebkit"; };

      libcap = { name = "libcap_progs"; native = true; userEnv = true; };

      openexr = { name = "ilmbase"; };

      pkgconfig = {
        name = "pkgconfig";
        propagated = true;
        native = true;
      };

      polkitqt = { name = "polkit_qt5_1"; };

      pythoninterp = {
        name = "python";
        native = true;
      };

      sharedmimeinfo = {
        name = "shared_mime_info";
        userEnv = true;
        propagated = true;
        native = true;
      };
    })

    (mapInputNames (name: if hasPrefix "qt5" name then "qt5" else name))

    (mapInputs (i:
      if hasPrefix "kf5" i.name && i.name != "kf5"
        then i // { name = "k" + removePrefix "kf5" i.name; propagated = true; }
      else i))
  ];

  scope = with pkgs; pkgs // {
    phonon = phonon_qt5;
    qt5 = qt53;
  };
}
