# Build an idris package
{ gccStdenv, lib, idrisPackages, gmp }:
  { idrisDeps ? []
  , noPrelude ? false
  , noBase ? false
  , name
  , version
  , extraBuildInputs ? []
  , ...
  }@attrs:
let
  allIdrisDeps = idrisDeps
    ++ lib.optional (!noPrelude) idrisPackages.prelude
    ++ lib.optional (!noBase) idrisPackages.base;
  idris-with-packages = idrisPackages.with-packages allIdrisDeps;
  newAttrs = builtins.removeAttrs attrs [ "idrisDeps" "extraBuildInputs" "name" "version" ] // {
    meta = attrs.meta // {
      platforms = attrs.meta.platforms or idrisPackages.idris.meta.platforms;
    };
  };
in
# We use gcc stdenv to get gcc calls on Darwin to work
gccStdenv.mkDerivation ({
  name = "idris-${name}-${version}";

  buildInputs = [ idris-with-packages gmp ] ++ extraBuildInputs;
  propagatedBuildInputs = allIdrisDeps;

  # Some packages use the style
  # opts = -i ../../path/to/package
  # rather than the declarative pkgs attribute so we have to rewrite the path.
  postPatch = ''
    sed -i *.ipkg -e "/^opts/ s|-i \\.\\./|-i ${idris-with-packages}/libs/|g"
  '';

  buildPhase = ''
    idris --build *.ipkg
  '';

  checkPhase = ''
    if grep -q test *.ipkg; then
      idris --testpkg *.ipkg
    fi
  '';

  installPhase = ''
    idris --install *.ipkg --ibcsubdir $out/libs
    IDRIS_DOC_PATH=$out/doc idris --installdoc *.ipkg || true
  '';

} // newAttrs)
