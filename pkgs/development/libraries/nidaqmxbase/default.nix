# This file provides Nix expressions for building the National Instruments NI-DAQmx Base.
# 
# TODO:
# - Split LabVIEW RTE into smaller packages. 
#     - labview-2015-rte-15.0.0/lib/liblvrtdark.so.15.0 should go into separate output to reduce closure size of cinterface
#
{ lib
, stdenv
, requireFile
, runCommand
, writeShellScript
, autoPatchelfHook
, p7zip
, rpm
, cpio
, libGL
, libXt
, libXinerama
}:

let
  version = "15.0.0";

  isoBasename = "nidaqmxbase-${version}";

  iso = requireFile rec {
    name = "${isoBasename}.iso";
    message = '' 
      This expression requires ${name} which can be fetched from the
      website of National Instruments.

      After downloading, run the following command in the download directory
      in order to load the artifact into the store

          nix-prefetch-url file://\$PWD/${name}

    '';
    sha256 = "1ylpzdp2nd6mbm3k03ayp44mab6vsm5j4fvqxkgnzr9v143iqjsr";
  };

  # Unpacked ISO
  unpacked = runCommand "${isoBasename}" {
    nativeBuildInputs = [ p7zip ];
  } ''
    7z x ${iso} -o$out
  '';

  # Add symbolic links to versioned .so files.
  # Would be useful to split this off in a hook.
  addSharedObjectVersioningLinksHook = writeShellScript "add-shared-object-versioning-links" ''
    addLinksForLibs ()
        for baselib in "$@"
        do
            shortlib=$baselib
            while extn=$(echo $shortlib | sed -n '/\.[0-9][0-9]*$/s/.*\(\.[0-9][0-9]*\)$/\1/p')
                [ -n "$extn" ]
            do
                shortlib=$(basename $shortlib $extn)
                ln -sf $baselib $shortlib
            done
        done
    
    addLinksInFolders ()
        for folder in ''${sharedObjectVersioningLinksFolders-}; do
            pushd "$folder"
            addLinksForLibs $(ls .)
            popd
        done

    echo "Adding links..."    
    if [ -z ''${dontCreateVersionedSharedObjectLinks-} ]; then
        postBuildHooks+=addLinksInFolders
    fi;
  '';

  buildNidaqPackage = 
    { pname
    , nativeBuildInputs ? []
    , rpmFile ? "${pname}-${version}-f1.x86_64.rpm"
    , ...
    } @ attrs:

    stdenv.mkDerivation ({
      inherit pname version;

      nativeBuildInputs = [ 
        addSharedObjectVersioningLinksHook 
        autoPatchelfHook 
        rpm 
        cpio 
      ] ++ nativeBuildInputs;

      unpackPhase = ''
        rpm2cpio ${unpacked}/${rpmFile} | cpio -idmv
      '';

      sharedObjectVersioningLinksFolders = [ "lib64" ];

      buildPhase = ''
        runHook preBuild

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        echo "Moving files to output..."
        mkdir -p $out

        mkdir -p $out/lib
        mv -T lib64 $out/lib

        if [ -d "include" ]; then
            mv include $out/
        fi

        addAutoPatchelfSearchPath "$out/lib"

        runHook postInstall
      '';

      meta = {
        license = lib.licenses.unfree;
        platforms = [ "x86_64-linux" ];
      };

    #   passthru = {
    #     inherit iso unpacked;
    #   };
    } // attrs);

  labview-rte = buildNidaqPackage rec {
    pname = "labview-2015-rte";

    sourceRoot = "usr/local";

    buildInputs = [ 
      libGL 
      libXt 
      libXinerama
    ];

    rpmFile = "labview-2015-rte-15.0.0-2.x86_64.rpm";

    #dontCreateVersionedSharedObjectLinks = true;

    # Move it to expected location so we can use default installation phase
    preBuild = ''
      echo "Renaming LabVIEW folder..."
      mv lib64 lib
      mv lib/LabVIEW-2015-64 lib64
    '';

    postBuild = ''
      # Ignore for now. Mostly because of libeay32.so dependency
      # If correct that is actually openssl but named differently.
      rm -rf lib64/webserver

      # Has a dependency on a different version than is bundled.
      rm lib64/mod_niesp.so*
    '';
  };

  nidaqmxbase-cinterface = buildNidaqPackage rec {
    pname = "nidaqmxbase-cinterface";

    buildInputs = [ 
      nidaqmxbase-common
    ];

    sourceRoot = "usr/local/natinst/nidaqmxbase";
  };

   nidaqmxbase-common = buildNidaqPackage rec {
    pname = "nidaqmxbase-common";

    buildInputs = [ 
      labview-rte
    ];

    sourceRoot = "usr/local/natinst/nidaqmxbase";
  };

in {
  inherit labview-rte nidaqmxbase-common nidaqmxbase-cinterface;
}