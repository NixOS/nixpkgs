{ stdenv, fetchurl, makeWrapper, autoPatchelfHook, gnused
, gcc, bash, gtk-engine-murrine, gtk_engines, librsvg

, libX11, libXext, libXi, libXau, libXrender, libXft, libXmu, libSM, libXcomposite, libXfixes, libXpm
, libXinerama, libXdamage, libICE, libXtst, libXaw, fontconfig, pango, cairo, glib, libxml2, atk, gtk2
, gdk_pixbuf, libGL, ncurses5

, dmidecode, pciutils, usbutils
}:

stdenv.mkDerivation rec {
  pname = "MaXX";
  version = "2.0.1";
  codename = "Indigo";

  srcs = [
    (fetchurl {
      url = "http://maxxdesktop.arcadedaydream.com/${codename}-Releases/Installers/MaXX-${codename}-${version}-x86_64.tar.gz";
      sha256 = "17hd3j8773kmvvhyf657in6zmhnw4mbvyn4r6dfip5bdaz66pj01";
    })
  ];

  nativeBuildInputs = [ makeWrapper autoPatchelfHook gnused ];
  buildInputs = [
    stdenv.cc.cc libX11 libXext libXi libXau libXrender libXft libXmu libSM libXcomposite libXfixes libXpm
    libXinerama libXdamage libICE libXtst libXaw fontconfig pango cairo glib libxml2 atk gtk2
    gdk_pixbuf libGL ncurses5
  ];

  buildPhase = ''
    sed -i "s/\(LD_LIBRARY_PATH=.*\)$/\1:\$LD_LIBRARY_PATH/p" etc/system.desktopenv

    substituteInPlace bin/adminterm \
      --replace /bin/bash ${bash}/bin/bash

    substituteInPlace share/misc/HOME/initMaXX-Desktop-Home.sh \
      --replace "cp " "cp --no-preserve=mode "
  '';

  installPhase = ''
    maxx=$out/opt/MaXX
    mkdir -p "$maxx" $out/share $maxx/sbin

    mv -- ./* "$maxx"
    ln -s $maxx/share/icons $out/share

    wrapProgram $maxx/etc/skel/Xsession.dt \
      --prefix GTK_PATH : "${gtk-engine-murrine}/lib/gtk-2.0:${gtk_engines}/lib/gtk-2.0" \
      --prefix GDK_PIXBUF_MODULE_FILE : "$(echo ${librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)"

    while IFS= read -r -d ''$'\0' i; do
      if isExecutable "$i"; then
        wrapProgram "$i" \
          --prefix PATH : ${gcc}/bin
      fi
    done < <(find "$maxx" -type f -print0)

    wrapProgram $maxx/bin/hinv \
      --prefix PATH : ${stdenv.lib.makeBinPath [ dmidecode pciutils usbutils ]}
  '';

  meta = with stdenv.lib; {
    description = "A replica of IRIX Interactive Desktop";
    homepage = https://www.facebook.com/maxxdesktop/;
    license = {
      fullName = "The MaXX Interactive Desktop for Linux License Agreement";
      url = http://maxxdesktop.arcadedaydream.com/Indigo-Releases/docs/license.html;
      free = false; # redistribution is only allowed to *some* hardware, etc.
    };
    maintainers = [ maintainers.gnidorah ];
    platforms = ["x86_64-linux"];
    longDescription = ''
      A clone of IRIX Interactive Desktop made in agreement with SGI. 
      Provides simple and fast retro desktop environment.
    '';
  };
}
