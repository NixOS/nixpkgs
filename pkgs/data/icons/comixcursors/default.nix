{ lib, stdenv, fetchFromGitLab, bc, librsvg, xcursorgen }:

let
  dimensions = {
    color = [ "Black" "Blue" "Green" "Orange" "Red" "White" ];
    opacity = [ "" "Opaque_" ];  # Translucent or opaque.
    thickness = [ "" "Slim_" ];  # Thick or slim edges.
    handedness = [ "" "LH_" ];   # Right- or left-handed.
  };
  product = lib.cartesianProductOfSets dimensions;
  variantName =
    { color, opacity, thickness, handedness }:
    "${handedness}${opacity}${thickness}${color}";
  variants =
    # (The order of this list is already good looking enough to show in the
    # meta.longDescription.)
    map variantName product;
in
stdenv.mkDerivation rec {
  pname = "comixcursors";
  version = "0.9.2";

  src = fetchFromGitLab {
    owner = "limitland";
    repo = "comixcursors";
    # https://gitlab.com/limitland/comixcursors/-/issues/3
    rev = "8c327c8514ab3a352583605c1ddcb7eb3d1d302b";
    sha256 = "0bpxqw4izj7m0zb9lnxnmsjicfw60ppkdyv5nwrrz4x865wb296a";
  };

  nativeBuildInputs = [ bc librsvg xcursorgen ];

  patches = [ ./makefile-shell-var.patch ];

  postPatch = ''
    patchShebangs ./install-all ./bin/
  '';

  # install-all is used instead of the directions in upstream's INSTALL file,
  # because using its Makefile directly is broken.  Upstream itself seems to use
  # its build-distribution script instead, which also uses install-all, but we
  # do not use it because it does extra things for other distros.
  #
  # When not all of the variants, i.e. only a smaller subset of them, are
  # desired (i.e. when a subset of outputs are chosen), install-all will still
  # build all of them.  While upstream appears to provide old functionality for
  # building only a subset, it is broken and we do not use it.  With prebuilt
  # substitutions, installers of this package will get only the outputs they
  # chose.
  buildPhase = ''
    ICONSDIR=$TMP/staged ./install-all
  '';

  installPhase = ''
    for outputName in $outputs ; do
      if [ $outputName != out ]; then
        local outputDir=''${!outputName};
        local iconsDir=$outputDir/share/icons
        local cursorName=$(tr _ - <<<"$outputName")

        mkdir -p $iconsDir
        cp -r -d $TMP/staged/ComixCursors-$cursorName $iconsDir

        unset outputDir iconsDir cursorName
      fi
    done

    # Need this directory (empty) to prevent the builder scripts from breaking.
    mkdir -p $out
  '';

  outputs = let
    default = "Opaque_Black";
  in
    # Have the most-traditional variant be the default output (as the first).
    # Even with outputsToInstall=[], the default/first still has an effect on
    # some Nix tools (e.g. nix-build).
    [ default ] ++ (lib.remove default variants)
    # Need a dummy "out" output to prevent the builder scripts from breaking.
    ++ [ "out" ];

  # No default output (to the extent possible).  Instead, the outputs'
  # attributes are used to choose which variant(s) to have.
  outputsToInstall = [];

  meta = with lib; {
    description = "The Comix Cursors mouse themes";
    longDescription = ''
      There are many (${toString ((length outputs) - 1)}) variants of color,
      opacity, edge thickness, and right- or left-handedness, for this cursor
      theme.  This package's derivation has an output for each of these
      variants, named following the upstream convention, and the attribute for
      an output must be used to install a variant.  E.g.:
      <programlisting language="nix">
      environment.systemPackages = [
        comixcursors.Blue
        comixcursors.Opaque_Orange
        comixcursors.Slim_Red
        comixcursors.Opaque_Slim_White
        comixcursors.LH_Green
        comixcursors.LH_Opaque_Black
        comixcursors.LH_Slim_Orange
        comixcursors.LH_Opaque_Slim_Blue
      ];
      </programlisting>

      Attempting to use just <literal>comixcursors</literal>, i.e. without an
      output attribute, will not install any variants.  To install all the
      variants, use <literal>comixcursors.all</literal> (which is a list), e.g.:
      <programlisting language="nix">
      environment.systemPackages = comixcursors.all ++ [...];
      </programlisting>

      The complete list of output attributes is:
      <programlisting>
      ${concatStringsSep "\n" variants}
      </programlisting>
    '';
    homepage = "https://gitlab.com/limitland/comixcursors";
    changelog = "https://gitlab.com/limitland/comixcursors/-/blob/HEAD/NEWS";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.DerickEddington ];
    platforms = platforms.all;
  };
}
