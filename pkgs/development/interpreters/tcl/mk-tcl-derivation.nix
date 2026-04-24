# Generic builder for tcl packages/applications
{
  tcl,
  lib,
  makeWrapper,
}:

let
  inherit (tcl) stdenv;
  inherit (lib) getBin optionalAttrs;

  defaultTclPkgConfigureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tclinclude=${tcl}/include"
    "--exec-prefix=${placeholder "out"}"
    # Enable stubs by default for compatibility across minor versions
    "--enable-stubs"
  ];

in
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "addTclConfigureFlags"
    "checkPhase"
    "checkInputs"
    "nativeCheckInputs"
    "doCheck"
  ];
  extendDrvArgs =
    finalAttrs:
    args@{
      # true if we should skip the configuration phase altogether
      dontConfigure ? false,

      # Extra flags passed to configure step
      configureFlags ? [ ],

      # Whether or not we should add common Tcl-related configure flags
      addTclConfigureFlags ? true,
      ...
    }:
    (
      {
        buildInputs = args.buildInputs or [ ] ++ [ tcl.tclPackageHook ];

        nativeBuildInputs =
          args.nativeBuildInputs or [ ]
          ++ [
            makeWrapper
            tcl
          ]
          ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
            tcl.tclRequiresCheckHook
          ];

        propagatedBuildInputs = args.propagatedBuildInputs or [ ] ++ [ tcl ];

        # Run tests after install, at which point we've done all TCLLIBPATH setup
        doCheck = false;
        doInstallCheck = args.doCheck or (args.doInstallCheck or false);
        installCheckInputs = args.checkInputs or [ ] ++ args.installCheckInputs or [ ];
        nativeInstallCheckInputs = args.nativeCheckInputs or [ ] ++ args.nativeInstallCheckInputs or [ ];

        # Add typical values expected by TEA for configureFlags
        configureFlags =
          if (!dontConfigure && addTclConfigureFlags) then
            (configureFlags ++ defaultTclPkgConfigureFlags)
          else
            configureFlags;

        env = {
          TCLSH = "${getBin tcl}/bin/tclsh";
        }
        // args.env or { };

        meta = {
          platforms = tcl.meta.platforms;
        }
        // args.meta or { };

      }
      // optionalAttrs (args ? checkPhase) {
        installCheckPhase = args.checkPhase;
      }
    );
}
