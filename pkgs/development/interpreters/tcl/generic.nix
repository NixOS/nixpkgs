{ lib, stdenv, callPackage, makeSetupHook, runCommand
, tzdata

# Version specific stuff
, release, version, src
, ...
}:

let
  baseInterp =
    stdenv.mkDerivation rec {
      pname = "tcl";
      inherit version src;

      outputs = [ "out" "man" ];

      setOutputFlags = false;

      postPatch = ''
        substituteInPlace library/clock.tcl \
          --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo" \
          --replace "/usr/share/lib/zoneinfo" "" \
          --replace "/usr/lib/zoneinfo" "" \
          --replace "/usr/local/etc/zoneinfo" ""
      '';

      preConfigure = ''
        cd unix
      '';

      configureFlags = [
        "--enable-threads"
        # Note: using $out instead of $man to prevent a runtime dependency on $man.
        "--mandir=${placeholder "out"}/share/man"
        "--enable-man-symlinks"
        # Don't install tzdata because NixOS already has a more up-to-date copy.
        "--with-tzdata=no"
        "tcl_cv_strtod_unbroken=ok"
      ] ++ lib.optional stdenv.is64bit "--enable-64bit";

      enableParallelBuilding = true;

      postInstall = let
        dllExtension = stdenv.hostPlatform.extensions.sharedLibrary;
      in ''
        make install-private-headers
        ln -s $out/bin/tclsh${release} $out/bin/tclsh
        ln -s $out/lib/libtcl${release}${dllExtension} $out/lib/libtcl${dllExtension}
      '';

      meta = with lib; {
        description = "The Tcl scripting language";
        homepage = "https://www.tcl.tk/";
        license = licenses.tcltk;
        platforms = platforms.all;
        maintainers = with maintainers; [ agbrooks ];
      };

      passthru = rec {
        inherit release version;
        libPrefix = "tcl${release}";
        libdir = "lib/${libPrefix}";
        tclPackageHook = callPackage ({ buildPackages }: makeSetupHook {
          name = "tcl-package-hook";
          propagatedBuildInputs = [ buildPackages.makeBinaryWrapper ];
          meta = {
            inherit (meta) maintainers platforms;
          };
        } ./tcl-package-hook.sh) {};
        # verify that Tcl's clock library can access tzdata
        tests.tzdata = runCommand "${pname}-test-tzdata" {} ''
          ${baseInterp}/bin/tclsh <(echo "set t [clock scan {2004-10-30 05:00:00} \
                                        -format {%Y-%m-%d %H:%M:%S} \
                                        -timezone :America/New_York]") > $out
        '';
      };
    };

  mkTclDerivation = callPackage ./mk-tcl-derivation.nix { tcl = baseInterp; };

in baseInterp.overrideAttrs (self: {
     passthru = self.passthru // {
       inherit mkTclDerivation;
     };
})
