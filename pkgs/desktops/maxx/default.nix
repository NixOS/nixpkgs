{ stdenv, fetchurl
, libX11, libXext, libXi, libXau, libXrender, libXft, libXmu, libSM, libXcomposite, libXfixes, libXpm
, libXinerama, libXdamage, libICE, libXtst
, fontconfig, pango, cairo, glib, libxml2, atk, gtk2, gdk_pixbuf, mesa_noglu, ncurses5
, bash }:

let
  version = "Indy-1.0.0";

  deps = [
    libX11 libXext libXi libXau libXrender libXft libXmu libSM libXcomposite libXfixes libXpm
    libXinerama libXdamage libICE libXtst
    stdenv.cc.cc fontconfig pango cairo glib libxml2 atk gtk2 gdk_pixbuf mesa_noglu ncurses5
  ];
in stdenv.mkDerivation {
  name = "MaXX-${version}";

  srcs = [
    (fetchurl {
      url = "http://maxxinteractive.com/downloads/${version}/FEDORA/MaXX-${version}-NO-ARCH.tar.gz";
      sha256 = "004ia6xl8y2hmbq7j98ppgiwffjc62224x9q6w5z17sjibs8xcvx";
    })
    (fetchurl {
      url = "http://maxxinteractive.com/downloads/${version}/FEDORA/MaXX-${version}-x86_64.tar.gz";
      sha256 = "134z7hinh01w43m6xiqgh939w5w79860g4kzsd911rfcl3z353av";
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
    ln -s $maxx/share/themes $out/share
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
