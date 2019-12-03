{ lib
, pkgs
, kernel ? null
, linuxHeaders ? null
, writeShellScript
# , stdenv
# , fetchurl
# , autoPatchelfHook
# , rpm
# , cpio
# , newScope

}:

let

  repo = lib.importJSON ./repo.json;

  # # Add symbolic links to versioned .so files.
  # addSharedObjectVersioningLinksHook = writeShellScript "add-shared-object-versioning-links" ''
  #   addLinksForLibs ()
  #       for baselib in "$@"
  #       do
  #           shortlib=$baselib
  #           while extn=$(echo $shortlib | sed -n '/\.[0-9][0-9]*$/s/.*\(\.[0-9][0-9]*\)$/\1/p')
  #               [ -n "$extn" ]
  #           do
  #               shortlib=$(basename $shortlib $extn)
  #               ln -sf $baselib $shortlib
  #           done
  #       done
    
  #   addLinksInFolders ()
  #       for folder in ''${sharedObjectVersioningLinksFolders-}; do
  #           pushd "$folder"
  #           addLinksForLibs $(ls .)
  #           popd
  #       done

  #   echo "Adding links..."    
  #   if [ -z ''${dontCreateVersionedSharedObjectLinks-} ]; then
  #       postBuildHooks+=addLinksInFolders
  #   fi;
  # '';

  builder =  
    { stdenv
    , kernel ? null
    , linuxHeaders ? null
    , rpm 
    , cpio 
    , autoPatchelfHook
    , fetchurl
    , self
    }:
    { pname
    , nativeBuildInputs ? []
    , propagatedBuildInputs ? []
    , enablePatchelf ? true
    , isKernelModule ? (lib.hasSuffix "dkms" pname)
    , ...
    } @ attrs:

    let
      build = if isKernelModule then kernelModuleBuilder else pkgBuilder;
      # isKernelModule = lib.hasSuffix "dkms" pname;
      dependencies = lib.attrValues (lib.getAttrs repo.packages."${pname}".dependencies self) 
        ++ lib.optionals (isKernelModule && (kernel!=null)) [ kernel ];
      allBuildInputs = dependencies ++ propagatedBuildInputs;
      nidaqInputs = [(placeholder "out")] ++ lib.filter (pkg: pkg?isNiDaqPackage) allBuildInputs;

      passthru = {
        isNiDaqPackage = true;
        inherit isKernelModule;
        inherit nidaqInputs;
        sourceFiles = stdenv.mkDerivation {
          name = "files-${pname}.txt";
          inherit src unpackCmd sourceRoot;
          nativeBuildInputs = [ rpm cpio ];
          dontBuild = true;
          installPhase = ''
            find . > $out
          '';
        };
      };

      meta = {
        license = lib.licenses.unfree;
        platforms = [ "x86_64-linux" ];
      };

      src = fetchurl {
        url = "${repo.url}/${repo.packages."${pname}".filename}";
        sha256 = "${repo.packages."${pname}".sha256}";
      };

      unpackCmd = ''
        mkdir build
        cd build
        rpm2cpio $curSrc | cpio -idmv 
      '';

      sourceRoot = ".";
    
      kernelModuleBuilder = let
        KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
        KERNELVER = kernel.dev.version;
      in stdenv.mkDerivation ( {
        inherit pname;
        version = "foo";
        inherit src unpackCmd sourceRoot;

        nativeBuildInputs = [ 
          rpm 
          cpio 
        ] ++ kernel.moduleBuildDependencies
          ++ nativeBuildInputs;

        makeFlags = [ 
          "-C src/*"
          "INSTALL_MOD_PATH=${placeholder "out"}"
        ];

        inherit KERNELDIR;
        INSTALL_MOD_PATH="${placeholder "out"}";

        patchPhase = ''
          runHook prePatch

          if [[ -d usr ]]; then
              mv usr/* .
              rmdir usr
          fi

          patchShebangs .

          mf="$(find . -type f -name Makefile)"

          sed -i "s:SYMVERDIR\s*=\s*/var:SYMVERDIR=$out:" "$mf"
          sed -i "s:SBINDIR\s*=\s*/usr/sbin:SBINDIR=$out/bin:" "$mf"

          # Maybe we should copy in the configure from nikal instead
          sed -i "s:KERNELVER=.*:KERNELVER=${KERNELVER}:" "$mf"
          sed -i "s:KERNELDIR=.*:KERNELDIR=${KERNELDIR}:" "$mf"
          sed -i "s:INSTALL_MOD_PATH=.*:INSTALL_MOD_PATH=${placeholder "out"}:" "$mf"
          sed -i "/_dep/d" "$mf"
        '' + ''
          runHook postPatch
        '';

        inherit passthru meta;
      } // attrs);

      pkgBuilder = stdenv.mkDerivation ({
        inherit pname;
        version = "foo";
        
        inherit src unpackCmd sourceRoot;

        nativeBuildInputs = [ 
          rpm 
          cpio 
        ] ++ lib.optionals enablePatchelf [
          autoPatchelfHook
        ] ++ nativeBuildInputs;

        propagatedBuildInputs = allBuildInputs;

        buildPhase = ''
          runHook preBuild

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out

          echo "Moving files to output..."
          if [[ -d usr ]]; then
              mv usr/* .
              rmdir usr
          fi
          if [[ $(ls -A . ) ]]; then
              
              mv * $out/
  
          else
              hasNoOutput=1
              dontAutoPatchelf=1
              echo "No files present."
          fi
        '' + lib.optionalString enablePatchelf ''
          if [[ -z $hasNoOutput ]]; then
            echo "Patching binaries..."
            for input in ${builtins.toString nidaqInputs}; do
                for folder in `find "$input" -type f -name "*.so*" | xargs -r dirname | sort | uniq`; do
                    echo "Autopatchelf will also search for libraries in $folder"
                    addAutoPatchelfSearchPath "$folder"
                done
            done
          fi
        '' + ''
          runHook postInstall
        '';

        inherit passthru meta;

      } // attrs);
    in build;

        # installPhase = ''
        #   runHook preInstall

        #   echo "Moving files to output..."
        #   mkdir -p $out

        #   if [ -d "usr/lib/x86_64-linux-gnu" ]; then
        #       mkdir -p $out/lib
        #       mv -T "usr/lib/x86_64-linux-gnu" "$out/lib"
        #       # if [ -d "$out/lib/${pname}/DataDictionaries" ]; then
        #       #   mv $out/lib/${pname}/DataDictionaries/* "$out/lib"
        #       #   rmdir $out/lib/${pname}/DataDictionaries
        #       # fi
        #   fi

        #   if [ -d "usr/local/share" ]; then
        #       mkdir -p $out/lib
        #       mv -T "usr/local/share" "$out/share"
        #   fi

        #   # if [ -d "include" ]; then
        #   #     mv include $out/
        #   # fi
        # '' + lib.optionalString enablePatchelf ''
        #   for input in ${builtins.toString nidaqInputs}; do
        #       for folder in `find "$input" -type f -name "*.so*" | xargs -r dirname | sort | uniq`; do
        #           echo "Autopatchelf will also search for libraries in $folder"
        #           addAutoPatchelfSearchPath "$folder"
        #       done
        #   done
        # '' + ''
        #   runHook postInstall
        # '';
    
          # sourceFiles = pkgs.runCommand "files-${pname}.txt" {
          #   nativeBuildInputs = [ rpm cpio ];
          # }''
          #   rpm -qpl ${src} > $out.txt
          # '';

    # Merge two lists into a mapping with keys and values
    zip = a: b: lib.listToAttrs (lib.zipListsWith (a: b: {name = "${a}"; value=b;} ) a b);

    names = lib.attrNames repo.packages;
    drvs = self: builtins.map (pname: self.buildNidaqPackage {inherit pname;}) names;

    # Create a tree to all file lists. Makes it easier to find files.
    allSourceLists = let
      paths = lib.catAttrs "sourceFiles" (builtins.filter lib.isDerivation (lib.attrValues packages));
    in pkgs.runCommand "files-nidaqmx" {} ''
      mkdir -p $out
      cd $out
      for path in ${builtins.toString paths}; do
          ln -s $path .
      done;
    '';

    packages = let
      ps = lib.makeScope pkgs.newScope (self: with self; {
        buildNidaqPackage = lib.makeOverridable (self.callPackage builder {inherit self kernel linuxHeaders;});
      } // (zip names (drvs self)));
    #   generated = self: super: zip names drvs;
      overrides = pkgs.callPackage ./overrides.nix { };
    in ps.overrideScope' overrides;

in {
  inherit repo;
  inherit packages;
  inherit allSourceLists;
  allPackages =  lib.attrValues packages;
}