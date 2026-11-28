{
  stdenv,
  buildFHSEnv,
  fetchurl,
  lib,
  zlib,
  gdbm,
  libxslt,
  libxml2,
  libuuid,
  readline,
  readline70,
  xz,
  cups,
  libaio,
  vulkan-loader,
  alsa-lib,
  libpulseaudio,
  libxcrypt-legacy,
  libGL,
  numactl,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxinerama,
  libxft,
  libxfixes,
  libxext,
  libxdmcp,
  libxdamage,
  libxcursor,
  libxcomposite,
  libxau,
  libx11,
  kmod,
  python3,
  autoPatchelfHook,
  makeWrapper,
  symlinkJoin,
  enableInstaller ? false,
  bzip2,
  sqlite,
  enableMacOSGuests ? false,
  fetchFromGitHub,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vmware-workstation";
  version = "26H1u1";
  build = "25688693";

  src = fetchurl {
    url = "https://archive.org/download/VMware-Workstation-Full-${finalAttrs.version}-${finalAttrs.build}.x86_64/VMware-Workstation-Full-${finalAttrs.version}-${finalAttrs.build}.x86_64.bundle";
    hash = "sha256-2oI8hTzH5XvnubBwyK7SD+nXX9UZrm8XWrHa/HKDAC4=";
  };

  vmware-unpack-env = buildFHSEnv {
    pname = "vmware-unpack-env";
    inherit (finalAttrs) version;
    targetPkgs = pkgs: [ zlib ];
  };

  unpackPhase = ''
    ${finalAttrs.vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${finalAttrs.src} --extract unpacked"
  '';

  macOSUnlockerSrc = fetchFromGitHub {
    owner = "paolo-projects";
    repo = "unlocker";
    tag = "3.0.5";
    hash = "sha256-JSEW1gqQuLGRkathlwZU/TnG6dL/xWKW4//SfE+kO0A=";
  };

  postPatch = lib.optionalString enableMacOSGuests ''
    cp -R "${finalAttrs.macOSUnlockerSrc}" unlocker/

    substituteInPlace unlocker/unlocker.py --replace \
      "/usr/lib/vmware/bin/" "$out/lib/vmware/bin"

    substituteInPlace unlocker/unlocker.py --replace \
      "/usr/lib/vmware/lib/libvmwarebase.so/libvmwarebase.so" "$out/lib/vmware/lib/libvmwarebase.so/libvmwarebase.so"
  '';

  readline70_compat63 = symlinkJoin {
    name = "readline70_compat63";
    paths = [ readline70 ];
    postBuild = ''
      ln -s $out/lib/libreadline.so $out/lib/libreadline.so.6
    '';
  };

  nativeBuildInputs = [
    python3
    finalAttrs.vmware-unpack-env
    autoPatchelfHook
    makeWrapper
  ]
  ++ lib.optionals enableInstaller [
    bzip2
    sqlite
    finalAttrs.readline70_compat63
  ]
  ++ lib.optionals enableMacOSGuests [ unzip ];

  buildInputs = [
    libxslt
    libxml2
    libuuid
    gdbm
    readline
    xz
    cups
    libaio
    vulkan-loader
    alsa-lib
    libpulseaudio
    libxcrypt-legacy
    libGL
    numactl
    libx11
    libxau
    libxcomposite
    libxcursor
    libxdamage
    libxdmcp
    libxext
    libxfixes
    libxft
    libxinerama
    libxi
    libxrandr
    libxrender
    libxscrnsaver
    libxtst
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p \
      $out/bin \
      $out/etc/vmware \
      $out/etc/init.d \
      $out/lib/vmware \
      $out/share/doc \
      $out/share/applications

    #### Replicate vmware-installer's order but VMX first because of appLoader
    ${lib.optionalString enableInstaller ''
      ## VMware installer
      echo "Installing VMware Installer"
      unpacked="unpacked/vmware-installer"
      vmware_installer_version=$(cat "unpacked/vmware-installer/manifest.xml" | grep -oPm1 "(?<=<version>)[^<]+")
      dest="$out/lib/vmware-installer/$vmware_installer_version"

      mkdir -p $dest
      cp -r $unpacked/vmis* $dest/
      cp -r $unpacked/sopython $dest/
      cp -r $unpacked/python $dest/
      cp -r $unpacked/cdsHelper $dest/
      cp -r $unpacked/vmware* $dest/
      cp -r $unpacked/bin $dest/
      cp -r $unpacked/lib $dest/

      chmod +x $dest/vmis-launcher $dest/sopython/* $dest/python/init.sh $dest/vmware-*
      ln -s $dest/vmware-installer $out/bin/vmware-installer

      mkdir -p $out/etc/vmware-installer
      cp ${./vmware-installer-bootstrap} $out/etc/vmware-installer/bootstrap
      sed -i -e "s,@@INSTALLERDIR@@,$dest," $out/etc/vmware-installer/bootstrap
      sed -i -e "s,@@IVERSION@@,$vmware_installer_version," $out/etc/vmware-installer/bootstrap
      sed -i -e "s,@@BUILD@@,${finalAttrs.build}," $out/etc/vmware-installer/bootstrap

      # create database of vmware guest tools
      mkdir -p $out/etc/vmware-installer/components
      database_filename=$out/etc/vmware-installer/database
      touch $database_filename
      sqlite3 "$database_filename" "CREATE TABLE settings(key VARCHAR PRIMARY KEY, value VARCHAR NOT NULL, component_name VARCHAR NOT NULL);"
      sqlite3 "$database_filename" "INSERT INTO settings(key,value,component_name) VALUES('db.schemaVersion','2','vmware-installer');"
      sqlite3 "$database_filename" "CREATE TABLE components(id INTEGER PRIMARY KEY, name VARCHAR NOT NULL, version VARCHAR NOT NULL, buildNumber INTEGER NOT NULL, component_core_id INTEGER NOT NULL, longName VARCHAR NOT NULL, description VARCHAR, type INTEGER NOT NULL);"
      for folder in unpacked/**/.installer ; do
        component="$(basename $(dirname $folder))"
        component_version=$(cat unpacked/$component/manifest.xml | grep -oPm1 "(?<=<version>)[^<]+")
        component_core_id=$([ "$component" == "vmware-installer" ] && echo "-1" || echo "1")
        type=$([ "$component" == "vmware-workstation" ] && echo "0" || echo "1")
        sqlite3 "$database_filename" "INSERT INTO components(name,version,buildNumber,component_core_id,longName,description,type) VALUES('$component','$component_version',${finalAttrs.build},$component_core_id,'$component','$component',$type);"
        mkdir -p $out/etc/vmware-installer/components/$component
        cp -r $folder/* $out/etc/vmware-installer/components/$component
      done
    ''}

    ## VMware Bootstrap
    echo "Installing VMware Bootstrap"
    cp ${./vmware-bootstrap} $out/etc/vmware/bootstrap
    sed -i -e "s,@@PREFIXDIR@@,$out," $out/etc/vmware/bootstrap

    ## VMware Config
    echo "Installing VMware Config"
    cp ${./vmware-config} $out/etc/vmware/config
    sed -i -e "s,@@VERSION@@,${finalAttrs.version}," $out/etc/vmware/config
    sed -i -e "s,@@BUILD@@,${finalAttrs.build}," $out/etc/vmware/config
    sed -i -e "s,@@PREFIXDIR@@,$out," $out/etc/vmware/config

    ## VMware VMX
    echo "Installing VMware VMX"
    unpacked="unpacked/vmware-vmx"
    if [ -d "$unpacked" ]; then
      [ -d "$unpacked/bin" ] && cp -r $unpacked/bin/* $out/bin/ || true
      [ -d "$unpacked/etc/modprobe.d" ] && cp -r $unpacked/etc/modprobe.d $out/etc/ || true
      [ -d "$unpacked/etc/init.d" ] && cp -r $unpacked/etc/init.d/* $out/etc/init.d/ || true
      [ -d "$unpacked/roms" ] && cp -r $unpacked/roms $out/lib/vmware/ || true
      [ -d "$unpacked/sbin" ] && cp -r $unpacked/sbin/* $out/bin/ || true

      [ -d "$unpacked/lib/libconf" ] && cp -r $unpacked/lib/libconf $out/lib/vmware/ || true
      [ -f "$out/lib/vmware/libconf/etc/fonts/fonts.conf" ] && rm $out/lib/vmware/libconf/etc/fonts/fonts.conf || true

      [ -d "$unpacked/lib/bin" ] && cp -r $unpacked/lib/bin $out/lib/vmware/ || true
      [ -d "$unpacked/lib/lib" ] && cp -r $unpacked/lib/lib $out/lib/vmware/ || true
      [ -d "$unpacked/lib/scripts" ] && cp -r $unpacked/lib/scripts $out/lib/vmware/ || true
      [ -d "$unpacked/lib/icu" ] && cp -r $unpacked/lib/icu $out/lib/vmware/ || true
      [ -d "$unpacked/lib/share" ] && cp -r $unpacked/lib/share $out/lib/vmware/ || true
      [ -d "$unpacked/lib/modules" ] && cp -r $unpacked/lib/modules $out/lib/vmware/ || true
      [ -d "$unpacked/lib/include" ] && cp -r $unpacked/lib/include $out/lib/vmware/ || true
      [ -f "$unpacked/extra/modules.xml" ] && cp -r $unpacked/extra/modules.xml $out/lib/vmware/modules/ || true
    fi

    # Generate .ko.cer files for module aggregation compatibility on modern kernels (7.3+)
    if [ -d "$out/lib/vmware/modules" ]; then
      find "$out/lib/vmware/modules" -name "*.ko" -print0 | while IFS= read -r -d "" ko; do
        touch "$ko.cer"
        touch "$(dirname "$ko")/$(basename "$ko" .ko).ko.cer"
      done
    fi

    [ -f "$out/lib/vmware/bin/appLoader" ] && ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-vmblock-fuse || true
    [ -d "$out/lib/vmware/icu" ] && ln -s $out/lib/vmware/icu $out/etc/vmware/icu || true

    # Replace vmware-modconfig with simple error dialog
    cp ${./vmware-modconfig} $out/bin/vmware-modconfig
    sed -i -e "s,ETCDIR=/etc/vmware,ETCDIR=$out/etc/vmware," $out/bin/vmware-modconfig

    # Patch dynamic libs in VMX binaries if they exist
    for binary in "mksSandbox" "mksSandbox-debug" "mksSandbox-stats" "vmware-vmx" "vmware-vmx-debug" "vmware-vmx-stats"
    do
      if [ -f "$out/lib/vmware/bin/$binary" ]; then
        patchelf \
          --add-needed ${libaio}/lib/libaio.so.1 \
          --add-needed ${vulkan-loader}/lib/libvulkan.so.1 \
          --add-needed ${alsa-lib}/lib/libasound.so \
          --add-needed ${libpulseaudio}/lib/libpulse.so.0 \
          --add-needed ${libGL}/lib/libEGL.so.1 \
          --add-needed ${numactl}/lib/libnuma.so.1 \
          --add-needed ${libx11}/lib/libX11.so.6 \
          --add-needed ${libxi}/lib/libXi.so.6 \
          --add-needed ${libGL}/lib/libGL.so.1 \
          $out/lib/vmware/bin/$binary
      fi
    done

    ## VMware USB Arbitrator
    echo "Installing VMware USB Arbitrator"
    unpacked="unpacked/vmware-usbarbitrator"
    if [ -d "$unpacked" ]; then
      [ -d "$unpacked/etc/init.d" ] && cp -r $unpacked/etc/init.d/* $out/etc/init.d/ || true
      [ -d "$unpacked/bin" ] && cp -r $unpacked/bin/* $out/bin/ || true
    fi
    [ -f "$out/lib/vmware/bin/appLoader" ] && ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-usbarbitrator || true

    ## VMware Player Setup
    echo "Installing VMware Player Setup"
    unpacked="unpacked/vmware-player-setup"
    if [ -d "$unpacked" ]; then
      mkdir -p $out/lib/vmware/setup
      [ -f "$unpacked/vmware-config" ] && cp $unpacked/vmware-config $out/lib/vmware/setup/ || true
    fi

    ## VMware Network Editor
    echo "Installing VMware Network Editor"
    unpacked="unpacked/vmware-network-editor"
    if [ -d "$unpacked/lib" ]; then
      cp -r $unpacked/lib/* $out/lib/vmware/ || true
    fi

    ## VMware Other Apps (26H1u1 replacement for player-app)
    echo "Installing VMware Other Apps"
    unpacked="unpacked/vmware-other-apps"
    if [ -d "$unpacked" ]; then
      [ -d "$unpacked/lib" ] && cp -r $unpacked/lib/* $out/lib/vmware/ || true
      [ -d "$unpacked/share" ] && cp -r $unpacked/share/* $out/share/ || true
      [ -d "$unpacked/bin" ] && cp -r $unpacked/bin/* $out/bin/ || true
      [ -d "$unpacked/doc" ] && cp -r $unpacked/doc/* $out/share/doc/ || true
    fi

    for target in "vmplayer" "vmware-enter-serial" "vmware-setup-helper" "licenseTool" "vmware-mount" "vmware-fuseUI" "vmware-app-control" "vmware-zenity"
    do
      [ -f "$out/lib/vmware/bin/appLoader" ] && ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/$target || true
    done

    [ -f "$out/lib/vmware/bin/vmware-mount" ] && ln -s $out/lib/vmware/bin/vmware-mount $out/bin/vmware-mount || true
    [ -f "$out/lib/vmware/bin/vmware-fuseUI" ] && ln -s $out/lib/vmware/bin/vmware-fuseUI $out/bin/vmware-fuseUI || true
    [ -f "$out/lib/vmware/bin/vmrest" ] && ln -s $out/lib/vmware/bin/vmrest $out/bin/vmrest || true

    # Patch vmplayer if it exists
    if [ -f "$out/bin/vmplayer" ]; then
      sed -i -e "s,ETCDIR=/etc/vmware,ETCDIR=$out/etc/vmware," $out/bin/vmplayer
      sed -i -e "s,/sbin/modprobe,${kmod}/bin/modprobe," $out/bin/vmplayer
    fi
    if [ -f "$out/share/applications/vmware-player.desktop" ]; then
      sed -i -e "s,@@BINARY@@,$out/bin/vmplayer," $out/share/applications/vmware-player.desktop
    fi

    ## VMware OVF Tool component
    echo "Installing VMware OVF Tool for Linux"
    unpacked="unpacked/vmware-ovftool"
    if [ -d "$unpacked" ]; then
      mkdir -p $out/lib/vmware-ovftool/
      cp -r $unpacked/* $out/lib/vmware-ovftool/
      chmod 755 $out/lib/vmware-ovftool/ovftool* || true
      [ -f "$out/lib/vmware-ovftool/ovftool.bin" ] && makeWrapper "$out/lib/vmware-ovftool/ovftool.bin" "$out/bin/ovftool" || true
    fi

    ## VMware Network Editor User Interface
    echo "Installing VMware Network Editor User Interface"
    unpacked="unpacked/vmware-network-editor-ui"
    if [ -d "$unpacked/share" ]; then
      cp -r $unpacked/share/* $out/share/ || true
    fi

    [ -f "$out/lib/vmware/bin/appLoader" ] && ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-netcfg || true
    [ -f "$out/lib/vmware/bin/vmware-netcfg" ] && ln -s $out/lib/vmware/bin/vmware-netcfg $out/bin/vmware-netcfg || true
    if [ -f "$out/share/applications/vmware-netcfg.desktop" ]; then
      sed -i -e "s,@@BINARY@@,$out/bin/vmware-netcfg," $out/share/applications/vmware-netcfg.desktop
    fi

    ## VMware VIX Core Library
    echo "Installing VMware VIX Core Library"
    unpacked="unpacked/vmware-vix-core"
    if [ -d "$unpacked" ]; then
      mkdir -p $out/lib/vmware-vix
      [ -d "$unpacked/lib" ] && cp -r $unpacked/lib/* $out/lib/vmware-vix/ || true
      [ -d "$unpacked/bin" ] && cp -r $unpacked/bin/* $out/bin/ || true
      cp -r $unpacked/*.txt $out/lib/vmware-vix/ 2>/dev/null || true

      mkdir -p $out/share/doc/vmware-vix/
      [ -d "$unpacked/doc" ] && cp -r $unpacked/doc/* $out/share/doc/vmware-vix/ || true

      mkdir -p $out/include/
      [ -d "$unpacked/include" ] && cp -r $unpacked/include/* $out/include/ || true
    fi

    ## VMware VIX Workstation Library
    echo "Installing VMware VIX Workstation Library"
    unpacked="unpacked/vmware-vix-lib-Workstation1700"
    if [ -d "$unpacked/lib" ]; then
      cp -r $unpacked/lib/* $out/lib/vmware-vix/ || true
    fi

    ## VMware VProbes component for Linux
    echo "Installing VMware VProbes component for Linux"
    unpacked="unpacked/vmware-vprobe"
    if [ -d "$unpacked" ]; then
      [ -d "$unpacked/bin" ] && cp -r $unpacked/bin/* $out/bin/ || true
      [ -d "$unpacked/lib" ] && cp -r $unpacked/lib/* $out/lib/vmware/ || true
    fi

    ## VMware Workstation
    echo "Installing VMware Workstation"
    unpacked="unpacked/vmware-workstation"
    if [ -d "$unpacked" ]; then
      [ -d "$unpacked/bin" ] && cp -r $unpacked/bin/* $out/bin/ || true
      [ -d "$unpacked/lib" ] && cp -r $unpacked/lib/* $out/lib/vmware/ || true
      [ -d "$unpacked/share" ] && cp -r $unpacked/share/* $out/share/ || true
      [ -d "$unpacked/man" ] && cp -r $unpacked/man $out/share/ || true
      [ -d "$unpacked/doc" ] && cp -r $unpacked/doc $out/share/ || true
    fi

    [ -f "$out/lib/vmware/bin/appLoader" ] && ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware || true
    [ -f "$out/lib/vmware/bin/appLoader" ] && ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-tray || true
    [ -f "$out/lib/vmware/bin/appLoader" ] && ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-vprobe || true

    # Patch vmware binary if it exists
    if [ -f "$out/bin/vmware" ]; then
      sed -i -e "s,ETCDIR=/etc/vmware,ETCDIR=$out/etc/vmware,g" $out/bin/vmware
      sed -i -e "s,/sbin/modprobe,${kmod}/bin/modprobe,g" $out/bin/vmware
    fi
    if [ -f "$out/share/applications/vmware-workstation.desktop" ]; then
      sed -i -e "s,@@BINARY@@,$out/bin/vmware," $out/share/applications/vmware-workstation.desktop
    fi

    chmod +x $out/bin/* $out/lib/vmware/bin/* 2>/dev/null || true
    [ -d "$out/lib/vmware/setup" ] && chmod +x $out/lib/vmware/setup/* 2>/dev/null || true

    # Hardcoded pkexec hack
    for lib in "lib/vmware/lib/libvmware-mount.so/libvmware-mount.so" "lib/vmware/lib/libvmwareui.so/libvmwareui.so" "lib/vmware/lib/libvmware-fuseUI.so/libvmware-fuseUI.so"
    do
      if [ -f "$out/$lib" ]; then
        sed -i -e "s,/usr/local/sbin,/run/vmware/bin," "$out/$lib"
      fi
    done

    ${lib.optionalString enableMacOSGuests ''
      echo "Running VMWare Unlocker to enable macOS Guests"
      python3 unlocker/unlocker.py
    ''}

    # SUID hack for vmx
    if [ -f "$out/lib/vmware/bin/vmware-vmx" ]; then
      wrapProgram $out/lib/vmware/bin/vmware-vmx
      rm $out/lib/vmware/bin/vmware-vmx
      ln -s /run/wrappers/bin/vmware-vmx $out/lib/vmware/bin/vmware-vmx
    fi

    # Remove shipped X11 libraries
    for lib in $out/lib/vmware/lib/* $out/lib/vmware-ovftool/lib*.so*; do
      if [ -e "$lib" ]; then
        lib_name="$(basename "$lib")"
        if [[ "$lib_name" == libX* || "$lib_name" == libxcb* ]]; then
          rm -rf "$lib"
        fi
      fi
    done

    for lib in $out/lib/vmware/lib/{libcroco-0.6.so.3/libcroco-0.6.so.3,librsvg-2.so.2/librsvg-2.so.2} $out/lib/vmware/libconf/lib/gtk-3.0/3.0.0/loaders/libpixbufloader-svg.so; do
      if [ -f "$lib" ]; then
        patchelf $lib --replace-needed libxml2.so.2 libxml2.so.16
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Industry standard desktop hypervisor for x86-64 architecture";
    homepage = "https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "vmware";
    maintainers = with lib.maintainers; [
      cawilliamson
      deinferno
      vifino
    ];
  };
})
