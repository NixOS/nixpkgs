# Build an idris package
{ stdenv, lib, idrisPackages, gmp }:
  { idrisDeps ? []
  , noPrelude ? false
  , noBase ? false
  , name
  , version
  , ipkgName ? name
  , extraBuildInputs ? []
  , ...
  }@attrs:
let
  allIdrisDeps = idrisDeps
    ++ lib.optional (!noPrelude) idrisPackages.prelude
    ++ lib.optional (!noBase) idrisPackages.base;
  idris-with-packages = idrisPackages.with-packages allIdrisDeps;
  newAttrs = builtins.removeAttrs attrs [
    "idrisDeps" "noPrelude" "noBase"
    "name" "version" "ipkgName" "extraBuildInputs"
  ] // {
    meta = attrs.meta // {
      platforms = attrs.meta.platforms or idrisPackages.idris.meta.platforms;
    };
  };
in
stdenv.mkDerivation ({
  name = "idris-${name}-${version}";

  buildInputs = [ idris-with-packages gmp ] ++ extraBuildInputs;
  propagatedBuildInputs = allIdrisDeps;

  # Some packages use the style
  # opts = -i ../../path/to/package
  # rather than the declarative pkgs attribute so we have to rewrite the path.
  postPatch = ''
    runHook prePatch
    sed -i ${ipkgName}.ipkg -e "/^opts/ s|-i \\.\\./|-i ${idris-with-packages}/libs/|g"
  '';

  buildPhase = ''
    runHook preBuild
    idris --build ${ipkgName}.ipkg
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    if grep -q tests ${ipkgName}.ipkg; then
      idris --testpkg ${ipkgName}.ipkg
    fi
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    idris --install ${ipkgName}.ipkg --ibcsubdir $out/libs

    IDRIS_DOC_PATH=$out/doc idris --installdoc ${ipkgName}.ipkg || true

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

} // newAttrs)
