# Build an idris package
{
  stdenv,
  lib,
  gmp,
  prelude,
  base,
  with-packages,
  idris,
}:
{
  idrisDeps ? [ ],
  noPrelude ? false,
  noBase ? false,
  pname,
  version,
  ipkgName ? pname,
  extraBuildInputs ? [ ],
  idrisBuildOptions ? [ ],
  idrisTestOptions ? [ ],
  idrisInstallOptions ? [ ],
  idrisDocOptions ? [ ],
  ...
}@attrs:
let
  allIdrisDeps = idrisDeps ++ lib.optional (!noPrelude) prelude ++ lib.optional (!noBase) base;
  idris-with-packages = with-packages allIdrisDeps;
  newAttrs =
    removeAttrs attrs [
      "idrisDeps"
      "noPrelude"
      "noBase"
      "pname"
      "version"
      "ipkgName"
      "extraBuildInputs"
    ]
    // {
      meta = attrs.meta // {
        platforms = attrs.meta.platforms or idris.meta.platforms;
      };
    };
in
stdenv.mkDerivation (
  {
    pname = "idris-${pname}";
    inherit version;

    buildInputs = [
      idris-with-packages
      gmp
    ]
    ++ extraBuildInputs;
    propagatedBuildInputs = allIdrisDeps;

    # Some packages use the style
    # opts = -i ../../path/to/package
    # rather than the declarative pkgs attribute so we have to rewrite the path.
    patchPhase = ''
      runHook prePatch
      sed -i ${ipkgName}.ipkg -e "/^opts/ s|-i \\.\\./|-i ${idris-with-packages}/libs/|g"
      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild
      idris --build ${ipkgName}.ipkg ${lib.escapeShellArgs idrisBuildOptions}
      runHook postBuild
    '';

    checkPhase = ''
      runHook preCheck
      if grep -q tests ${ipkgName}.ipkg; then
        idris --testpkg ${ipkgName}.ipkg ${lib.escapeShellArgs idrisTestOptions}
      fi
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      idris --install ${ipkgName}.ipkg --ibcsubdir $out/libs ${lib.escapeShellArgs idrisInstallOptions}

      IDRIS_DOC_PATH=$out/doc idris --installdoc ${ipkgName}.ipkg ${lib.escapeShellArgs idrisDocOptions} || true

      # If the ipkg file defines an executable, install that
      executable=$(grep -Po '^executable = \K.*' ${ipkgName}.ipkg || true)
      # $executable intentionally not quoted because it must be quoted correctly
      # in the ipkg file already
      if [ ! -z "$executable" ] && [ -f $executable ]; then
        mkdir -p $out/bin
        mv $executable $out/bin/$executable
      fi

      runHook postInstall
    '';

  }
  // newAttrs
)
