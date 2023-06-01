{ stdenvNoCC
, lib
, fetchzip
, xorg
, hicolor-icon-theme
}:

stdenvNoCC.mkDerivation rec {
  pname = "vanilla-dmz";
  version = "0.4.5";

  src = fetchzip {
    url = "mirror://debian/pool/main/d/dmz-cursor-theme/dmz-cursor-theme_${version}.tar.xz";
    sha256 = "14r8fri4byyzavzdifpga6118hxqjwpzd11xxj28s16zxcanq16m";
  };

  buildInputs = [
    xorg.xcursorgen
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  buildPhase = ''
    runHook preBuild

    for theme in DMZ-{White,Black}; do
      pushd $theme/pngs
      ./make.sh
      popd
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for theme in DMZ-{White,Black}; do
      mkdir -p $out/share/icons/$theme/cursors
      cp -a $theme/xcursors/* $out/share/icons/$theme/cursors/
      install -m644 $theme/index.theme $out/share/icons/$theme/index.theme
    done

    ln -s $out/share/icons/{DMZ-White,Vanilla-DMZ}
    ln -s $out/share/icons/{DMZ-Black,Vanilla-DMZ-AA}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://jimmac.musichall.cz";
    description = "A style neutral scalable cursor theme";
    platforms = platforms.all;
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ cstrahan ];
  };
}
