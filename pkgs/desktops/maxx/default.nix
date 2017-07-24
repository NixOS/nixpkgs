{ stdenv, fetchurl
, libX11, libXext, libXi, libXau, libXrender, libXft, libXmu, libSM, libXcomposite, libXfixes, libXpm
, libXinerama, libXdamage, libICE, libXtst, libXaw
, fontconfig, pango, cairo, glib, libxml2, atk, gtk2, gdk_pixbuf, mesa_noglu, ncurses
, bash }:

let
  version = "Indy-1.1.0";

  deps = [
    libX11 libXext libXi libXau libXrender libXft libXmu libSM libXcomposite libXfixes libXpm
    libXinerama libXdamage libICE libXtst libXaw
    stdenv.cc.cc fontconfig pango cairo glib libxml2 atk gtk2 gdk_pixbuf mesa_noglu ncurses
  ];
in stdenv.mkDerivation {
  name = "MaXX-${version}";

  srcs = [
    (fetchurl {
      url = "http://maxxinteractive.com/downloads/${version}/FEDORA/MaXX-${version}-NO-ARCH.tar.gz";
      sha256 = "1d23j08wwrrn5cp7csv70pcz9jppcn0xb1894wkp0caaliy7g31y";
    })
    (fetchurl {
      url = "http://maxxinteractive.com/downloads/${version}/FEDORA/MaXX-${version}-x86_64.tar.gz";
      sha256 = "156p2lra184wyvibrihisd7cr1ivqaygsf0zfm26a12gx23b7708";
    })
  ];

  buildPhase = ''
    while IFS= read -r -d $'\0' i; do
      if isELF "$i"; then
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i" || true
        patchelf --set-rpath "${stdenv.lib.makeLibraryPath deps}" "$i"
      fi
    done < <(find "." -type f -print0)

    substituteInPlace bin/adminterm \
      --replace /bin/bash ${bash}/bin/bash

    substituteInPlace share/misc/HOME/initMaXX-Desktop-Home.sh \
      --replace "cp " "cp --no-preserve=mode "
  '';

  installPhase = ''
    maxx=$out/opt/MaXX
    mkdir -p "$maxx" $out/share

    mv -- ./* "$maxx"
    ln -s $maxx/share/icons $out/share
  '';

  meta = with stdenv.lib; {
    description = "A replica of IRIX Interactive Desktop";
    homepage = http://www.maxxinteractive.com;
    license = licenses.free;
    maintainers = [ maintainers.gnidorah ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
    longDescription = ''
      A clone of IRIX Interactive Desktop made in agreement with SGI. 
      Provides simple and fast retro desktop environment.
    '';
  };
}
