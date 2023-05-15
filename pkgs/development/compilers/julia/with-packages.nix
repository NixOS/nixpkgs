{ lib, buildFHSEnv, callPackage, julia, fetchurl }:

# The function `withPackages` can be used to create a Julia environment
# with a specified set of packages as shown by the following example
#
# pkgs.julia-bin.withPackages (p: with p; [ Plots ])
#
# The argument specifies a list of packages available in `<nixpkgs>`.
#
# The reason for using the attribute `requiredJuliaPackages` rather than
# `propagatedBuildInputs` is that the dependencies must be installed as well.
#
# Packages artifacts are specified in a similar way with the addition of the
# `isArtifact` attribute. This is so because they need to be treated differently.
# The attribute 'juliaPath' is the relative path in the collection of packages
# and is calculated by Julia's package manager and uniquely identify a package.

let juliaPackages = lib.recurseIntoAttrs
      (callPackage ../../../top-level/julia-packages.nix { inherit julia; }).pkgs;

    withPackages = nix:
      let nixPackages = (nix juliaPackages);
      in callPackage ./build-env.nix {
        julia = julia-env;
        extraPackages = juliaPackages.computeRequiredJuliaPackages nixPackages;
      };

    julia-env =  buildFHSEnv {
      name = "julia";

      targetPkgs = pkgs: (with pkgs; [ julia ]);

      # FONTCONFIG_FILE is needed to make Julia's fontconfig artifact
      # find the system fonts.
      #
      # On Wayland, without setting GDK_BACKEND to X11, we get
      # "Gdk-CRITICAL" messages.  We may remove it in the future. The
      # '*' means that if X11 is not available, it will try other
      # backends.
      profile = ''
        export FONTCONFIG_FILE=/etc/fonts/fonts.conf
        export GDK_BACKEND="x11,*"
      '';

      runScript = "${julia}/bin/julia";

      passthru = {
        inherit juliaPackages withPackages;
        julia-unwrapped = julia;
        inherit (julia) meta version;
      };

    };
in julia-env
