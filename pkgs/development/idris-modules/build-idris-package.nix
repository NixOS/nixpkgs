# Build an idris package
{ stdenv, lib, idrisPackages, gmp }:
  { idrisDeps ? []
  , includePreludeBase ? true
  , name
  , version
  , extraBuildInputs ? []
  , ...
  }@attrs:
let
  idrisDeps' = idrisDeps ++ lib.optionals includePreludeBase (with idrisPackages; [ prelude base ]);
  idris-with-packages = idrisPackages.with-packages idrisDeps';
  newAttrs = builtins.removeAttrs attrs [ "idrisDeps" "extraBuildInputs" "name" "version" ] // {
    meta = attrs.meta // {
      platforms = attrs.meta.platforms or idrisPackages.idris.meta.platforms;
    };
  };
in
stdenv.mkDerivation ({
  name = "${name}-${version}";

  buildInputs = [ idris-with-packages gmp ] ++ extraBuildInputs;
  propagatedBuildInputs = idrisDeps';

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
