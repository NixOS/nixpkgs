# Generic builder for tcl packages/applications, generally based on mk-python-derivation.nix
{ tcl
, lib
, makeWrapper
, runCommand
, writeScript
}:

{ buildInputs ? []
, nativeBuildInputs ? []
, propagatedBuildInputs ? []
, checkInputs ? []

# true if we should skip the configuration phase altogether
, dontConfigure ? false

# Extra flags passed to configure step
, configureFlags ? []

# Whether or not we should add common Tcl-related configure flags
, addTclConfigureFlags ? true

, meta ? {}
, passthru ? {}
, doCheck ? true
, ... } @ attrs:

let
  inherit (tcl) stdenv;
  inherit (lib) getBin optionalAttrs optionals;

  defaultTclPkgConfigureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tclinclude=${tcl}/include"
    "--exec-prefix=${placeholder "out"}"
  ];

  self = (stdenv.mkDerivation ((builtins.removeAttrs attrs [
    "addTclConfigureFlags" "checkPhase" "checkInputs" "doCheck"
  ]) // {

    buildInputs = buildInputs ++ [ tcl.tclPackageHook ];
    nativeBuildInputs = nativeBuildInputs ++ [ makeWrapper tcl ];
    propagatedBuildInputs = propagatedBuildInputs ++ [ tcl ];

    TCLSH = "${getBin tcl}/bin/tclsh";

    # Run tests after install, at which point we've done all TCLLIBPATH setup
    doCheck = false;
    doInstallCheck = attrs.doCheck or ((attrs ? doInstallCheck) && attrs.doInstallCheck);
    installCheckInputs = checkInputs ++ (optionals (attrs ? installCheckInputs) attrs.installCheckInputs);

    # Add typical values expected by TEA for configureFlags
    configureFlags =
      if (!dontConfigure && addTclConfigureFlags)
        then (configureFlags ++ defaultTclPkgConfigureFlags)
        else configureFlags;

    meta = {
      platforms = tcl.meta.platforms;
    } // meta;


  } // optionalAttrs (attrs?checkPhase) {
    installCheckPhase = attrs.checkPhase;
  }
  ));

in lib.extendDerivation true passthru self
