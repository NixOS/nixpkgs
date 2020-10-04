{ stdenv, fetchurl
, buildPackages
, pkgconfig, which, makeWrapper
, zlib, bzip2, libpng, gnumake, glib, libtool, xorg

, # FreeType supports LCD filtering (colloquially referred to as sub-pixel rendering).
  # LCD filtering is also known as ClearType and covered by several Microsoft patents.
  # This option allows it to be disabled. See http://www.freetype.org/patents.html.
  useEncumberedCode ? true
}:

let
  inherit (stdenv.lib) optional optionalString;

in stdenv.mkDerivation rec {
  pname = "freetype";
  version = "2.10.2";

  meta = with stdenv.lib; {
    description = "A font rendering engine";
    longDescription = ''
      FreeType is a portable and efficient library for rendering fonts. It
      supports TrueType, Type 1, CFF fonts, and WOFF, PCF, FNT, BDF and PFR
      fonts. It has a bytecode interpreter and has an automatic hinter called
      autofit which can be used instead of hinting instructions included in
      fonts.
    '';
    homepage = "https://www.freetype.org/";
    license = licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };

  srcs = [
    (fetchurl {
      url = "mirror://savannah/${pname}/${pname}-${version}.tar.xz";
      sha256 = "12rd181yzz6952cyjqaa4253f5szam93cmhw18p33rnj4l8dchqm";
    })

    (fetchurl {
      url = "mirror://savannah/freetype/ft2demos-${version}.tar.xz";
      sha256 = "1akd5n47qfn4ldap1nvkbdj3s5pfcmbifjc5d1cqdm2kpb8nbkix";
    })
  ];

  sourceRoot = "freetype2";

  dontMakeSourcesWritable = true;

  postUnpack = ''
    mv freetype-${version} freetype2
  '';

  propagatedBuildInputs = [ zlib bzip2 libpng xorg.libX11 ]; # needed when linking against freetype

  # dependence on harfbuzz is looser than the reverse dependence
  nativeBuildInputs = [ pkgconfig which makeWrapper libtool ]
    # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
    ++ optional (!stdenv.isLinux) gnumake;

  patches =
    [ ./enable-table-validation.patch
    ] ++
    optional useEncumberedCode ./enable-subpixel-rendering.patch;

  outputs = [ "out" "dev" "demos" ];

  configureFlags = [ "--bindir=$(dev)/bin" "--enable-freetype-config" ];

  # native compiler to generate building tool
  CC_BUILD = "${buildPackages.stdenv.cc}/bin/cc";

  # The asm for armel is written with the 'asm' keyword.
  CFLAGS = optionalString stdenv.isAarch32 "-std=gnu99";

  enableParallelBuilding = true;

  doCheck = true;

  postPatch = ''
    pushd ../ft2demos-${version}
    echo "Applying demos patches"
    cat ${./fix-find-libX11.patch} | patch -p1
    popd
  '';

  postBuild = ''
    pushd ../ft2demos-${version}
    unset preBuild postBuild
    echo "Building demos"
    buildPhase
    popd
  '';

  postInstall = glib.flattenInclude + ''
    substituteInPlace $dev/bin/freetype-config \
      --replace ${buildPackages.pkgconfig} ${pkgconfig}

    wrapProgram "$dev/bin/freetype-config" \
      --set PKG_CONFIG_PATH "$PKG_CONFIG_PATH:$dev/lib/pkgconfig"

    mkdir -p $demos/bin

    for program in ../ft2demos-${version}/bin/{f,t}t*; do
      libtool --mode=install install "$program" $demos/bin
    done
  '';

}
