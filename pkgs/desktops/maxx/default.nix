{ stdenv, fetchurl, makeWrapper, libredirect, gcc-unwrapped, bash, gtk-engine-murrine, gtk_engines, librsvg

, libX11, libXext, libXi, libXau, libXrender, libXft, libXmu, libSM, libXcomposite, libXfixes, libXpm
, libXinerama, libXdamage, libICE, libXtst, libXaw, fontconfig, pango, cairo, glib, libxml2, atk, gtk2
, gdk_pixbuf, mesa_noglu, ncurses

, xclock, xsettingsd }:

let
  version = "Indy-1.1.0";

  deps = [
    stdenv.cc.cc libX11 libXext libXi libXau libXrender libXft libXmu libSM libXcomposite libXfixes libXpm
    libXinerama libXdamage libICE libXtst libXaw fontconfig pango cairo glib libxml2 atk gtk2
    gdk_pixbuf mesa_noglu ncurses
  ];
  runtime_deps = [
    xclock xsettingsd
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

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    while IFS= read -r -d $'\0' i; do
      substituteInPlace "$i" --replace /opt/MaXX $out/opt/MaXX
    done < <(find "." -type f -exec grep -Iq /opt/MaXX {} \; -and -print0)

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

    wrapProgram $maxx/etc/skel/Xsession.dt \
      --prefix GTK_PATH : "${gtk-engine-murrine}/lib/gtk-2.0:${gtk_engines}/lib/gtk-2.0" \
      --prefix GDK_PIXBUF_MODULE_FILE : "$(echo ${librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)" \
      --prefix PATH : ${stdenv.lib.makeBinPath runtime_deps}

    while IFS= read -r -d $'\0' i; do
      if isELF "$i"; then
        bin=`patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i"; echo $?`
        patchelf --set-rpath "${stdenv.lib.makeLibraryPath deps}" "$i"
        if [ "$bin" -eq 0 ]; then
          wrapProgram "$i" \
            --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
            --set NIX_REDIRECTS /opt/MaXX=$maxx
        fi
      fi
    done < <(find "$maxx" -type f -print0)

    cp ${gcc-unwrapped}/bin/cpp ${gcc-unwrapped}/libexec/gcc/*/*/cc1 $maxx/bin
    for i in $maxx/bin/cpp $maxx/bin/cc1
    do
      wrapProgram "$i" \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS /opt/MaXX=$maxx
    done
  '';

  meta = with stdenv.lib; {
    description = "A replica of IRIX Interactive Desktop";
    homepage = http://www.maxxinteractive.com;
    license = {
      url = http://www.maxxinteractive.com/site/?page_id=97;
      free = true;
    };
    maintainers = [ maintainers.gnidorah ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
    longDescription = ''
      A clone of IRIX Interactive Desktop made in agreement with SGI. 
      Provides simple and fast retro desktop environment.
    '';
  };
}
