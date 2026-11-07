{
  lib,
  newScope,
  fetchgit,
  fetchurl,
  cmake,
  python3,
  bash,
  libgdiplus,
  libx11,
  unixodbc,
}:

lib.makeScope newScope (
  self:
  let
    baseCflags = lib.concatStringsSep " " [
      "-O2"
      "-g"
      "-DARG_MAX=500"
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
      "-Wno-error=implicit-int"
      "-Wno-error=return-mismatch"
    ];
    baseCflagsWithIntConversion = "${baseCflags} -Wno-error=int-conversion";
    fetchMonoExternal =
      name: rev: hash:
      fetchgit {
        url = "https://github.com/mono/${name}.git";
        inherit rev hash;
      };
    guixMonoPatchRev = "09be58292f6c8795d7e9723a58d9b32c8177cf34";
    fetchGuixMonoPatch =
      name: hash:
      fetchurl {
        url = "https://codeberg.org/guix/guix/raw/commit/${guixMonoPatchRev}/gnu/packages/patches/${name}";
        inherit hash;
      };
    guixPatches = {
      "corefx-mono-5.4.0-patches.patch" =
        fetchGuixMonoPatch "corefx-mono-5.4.0-patches.patch" "sha256-jaltVGiBt7eNXh0KjerMcuq3L8CRKZaHY8rRpGQXcLg=";
      "corefx-mono-pre-5.8.0-patches.patch" =
        fetchGuixMonoPatch "corefx-mono-pre-5.8.0-patches.patch" "sha256-f1r7ktS3e0bCTwW3t2V4ioF59/+aunyYsSswsFdJMrg=";
      "mono-1.2.6-bootstrap.patch" =
        fetchGuixMonoPatch "mono-1.2.6-bootstrap.patch" "sha256-ILvVFM0DnwGUELRbDORwHmLPSBEA6ndSuR75sPvmnLo=";
      "mono-1.9.1-add-MONO_CREATE_IMAGE_VERSION.patch" =
        fetchGuixMonoPatch "mono-1.9.1-add-MONO_CREATE_IMAGE_VERSION.patch" "sha256-XLeFscltiit0QDOwgB0jYuZjcO23XXaPwjYSChse/NI=";
      "mono-1.9.1-fixes.patch" =
        fetchGuixMonoPatch "mono-1.9.1-fixes.patch" "sha256-yA34QM3iSzZmVPl0SG9AJdmWsfx12sYfE3vHrmyJXU8=";
      "mono-2.4.2.3-fixes.patch" =
        fetchGuixMonoPatch "mono-2.4.2.3-fixes.patch" "sha256-LCJyNTUfppiOxvrLzRJyyjjtYfwd20AkBPGX+GlCdOc=";
      "mono-2.6.4-fixes.patch" =
        fetchGuixMonoPatch "mono-2.6.4-fixes.patch" "sha256-w62DG4rtYLgKhYSr97fPc28dC3+K/+lcig5OAkOXJpw=";
      "mono-4.9.0-fix-runtimemetadataversion.patch" =
        fetchGuixMonoPatch "mono-4.9.0-fix-runtimemetadataversion.patch" "sha256-cm3YJKs+RI1AVrZ+HfBiD9SlYjwc7kniRKTD3gT67VI=";
      "mono-5.4.0-patches.patch" =
        fetchGuixMonoPatch "mono-5.4.0-patches.patch" "sha256-yCZ/f1f2/58T1Gbe5VhL5ysKTJ1uP2JMe8wO+m8HIGg=";
      "mono-5.8.0-patches.patch" =
        fetchGuixMonoPatch "mono-5.8.0-patches.patch" "sha256-3LEvgLPbfm5KDjyXo1AY7/vVNRFcYde0w7kRxHGohxs=";
      "mono-6.12.0-fix-AssemblyResolver.patch" =
        fetchGuixMonoPatch "mono-6.12.0-fix-AssemblyResolver.patch" "sha256-sLwbs4KOarG6vfQzpG6QWgOZcu6hdl3L9FGDP2V5ups=";
      "mono-6.12.0-fix-ConditionParser.patch" =
        fetchGuixMonoPatch "mono-6.12.0-fix-ConditionParser.patch" "sha256-pTXuDLgChoSDjPI+MuzPXjkCeAY9gMsM0petuW9Qobc=";
      "mono-mcs-patches-from-5.10.0.patch" =
        fetchGuixMonoPatch "mono-mcs-patches-from-5.10.0.patch" "sha256-UdciaWIr/gTmGpiABW4yzXyBIXbW3xAahA4q7h5KWC4=";
      "pnet-fix-line-number-info.patch" =
        fetchGuixMonoPatch "pnet-fix-line-number-info.patch" "sha256-998Gz5sQahG/licd1p0iuDT8B0ArF0aMH404J+ozdMs=";
      "pnet-fix-off-by-one.patch" =
        fetchGuixMonoPatch "pnet-fix-off-by-one.patch" "sha256-RAyyRNv3T85E/JjsodF1WMKFqnZHt+QIrsCTVvfQ8xY=";
      "pnet-newer-libgc-fix.patch" =
        fetchGuixMonoPatch "pnet-newer-libgc-fix.patch" "sha256-XCzWEtYJk/IK+nYgR2vz2mxHV68VttO3i45dYOHM9n4=";
      "pnet-newer-texinfo-fix.patch" =
        fetchGuixMonoPatch "pnet-newer-texinfo-fix.patch" "sha256-yaqKIte5TW9JzlZ2vSH/nN65jTapwV1nJGwZLA7atPA=";
    };
    mkMono = args: self.callPackage ./mono.nix ({ cflags = baseCflags; } // args);
    copyExternalRepos =
      repos:
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: src: ''
          rm -rf external/${name}
          cp -R ${src} external/${name}
          chmod -R u+w external/${name}
        '') repos
      );
  in
  {
    treecc = self.callPackage ./treecc.nix { };
    pnet = self.callPackage ./pnet.nix {
      inherit (self) treecc;
      inherit guixPatches;
    };
    pnetlib = self.callPackage ./pnetlib.nix {
      inherit (self) pnet treecc;
    };

    mono-1_2_6 = mkMono {
      version = "1.2.6";
      src = fetchurl {
        url = "http://download.mono-project.com/sources/mono/mono-1.2.6.tar.bz2";
        hash = "sha256-JMxPOWysMFPHuj/mi8G4A1nXXcT1SoXzmnPKvD0/Vg8=";
      };
      patches = [ guixPatches."mono-1.2.6-bootstrap.patch" ];
      bootstrapCompiler = self.pnet;
      bootstrapRuntime = self.pnet;
      bootstrapLibraries = self.pnetlib;
      configureFlags = [ "--with-gc=boehm" ];
      makeFlags = [
        "EXTERNAL_MCS=${lib.getBin self.pnet}/bin/cscc"
        "EXTERNAL_RUNTIME=${lib.getBin self.pnet}/bin/ilrun"
        "V=1"
      ];
      enableParallelBuilding = true;
      doCheck = false;
    };

    mono-1_9_1 = mkMono {
      version = "1.9.1";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "fa2352e7bba168ce21f63ccdb59cce70e69b0b98";
        hash = "sha256-mq8RXKWSGJQfJHoC/VK44tPz5Qy0uV51mlQJBtsfNmg=";
      };
      patches = [
        guixPatches."mono-1.9.1-fixes.patch"
        guixPatches."mono-1.9.1-add-MONO_CREATE_IMAGE_VERSION.patch"
      ];
      bootstrapCompiler = self.mono-1_2_6;
      bootstrapRuntime = self.mono-1_2_6;
      configureFlags = [ "--with-gc=boehm" ];
      makeFlags = [
        "NO_SIGN_ASSEMBLY=yes"
        "V=1"
      ];
      enableParallelBuilding = true;
      doCheck = false;
      extraPostPatch = ''
        patchShebangs mcs/tools
      '';
      extraPreConfigure = ''
        export MONO_CREATE_IMAGE_VERSION=v1.1.4322
      '';
      extraPostConfigure = ''
        if [ -f mcs/class/IBM.Data.DB2/Makefile ]; then
          substituteInPlace mcs/class/IBM.Data.DB2/Makefile \
            --replace-fail "LIB_MCS_FLAGS =" "LIB_MCS_FLAGS = /delaysign+ "
        fi
        if [ -f mcs/class/FirebirdSql.Data.Firebird/Assembly/AssemblyInfo.cs ]; then
          substituteInPlace mcs/class/FirebirdSql.Data.Firebird/Assembly/AssemblyInfo.cs \
            --replace-fail "AssemblyDelaySign(false)" "AssemblyDelaySign(true)"
        fi
      '';
      extraPreInstall = ''
        find . -type f -name '*.mdb' -delete
      '';
    };

    mono-2_4_2 = mkMono {
      version = "2.4.2.3";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "f79a3230c2f0a8d80b36cdbe067c53e36374a017";
        hash = "sha256-qt2pkQH1+J3vjoEslJK2YarE0lACwQYGzIWllk+Y2VY=";
      };
      patches = [ guixPatches."mono-2.4.2.3-fixes.patch" ];
      bootstrapCompiler = self.mono-1_9_1;
      bootstrapRuntime = self.mono-1_9_1;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [ "--with-gc=boehm" ];
      makeFlags = [ "V=1" ];
      enableParallelBuilding = true;
      doCheck = false;
      extraPostPatch = ''
        mkdir -p m4
        if [ -f mono/mini/Makefile.am ]; then
          substituteInPlace mono/mini/Makefile.am \
            --replace-fail '`date`' 'Tue Jan  1 12:00:00 AM UTC 1980'
        fi
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
    };

    mono-2_6_4 = mkMono {
      version = "2.6.4";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "680b5eb2d695de54fe4eb3210c07722ef60e5a4b";
        hash = "sha256-BTFSMl5jy9+47Rcs1IdGrTsS9UARLkK1qxJBXAg/J50=";
      };
      patches = [ guixPatches."mono-2.6.4-fixes.patch" ];
      bootstrapCompiler = self.mono-2_4_2;
      bootstrapRuntime = self.mono-2_4_2;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [ "--with-gc=boehm" ];
      makeFlags = [ "V=1" ];
      enableParallelBuilding = true;
      doCheck = false;
      patchReflectionFormatStrings = false;
      extraPostPatch = ''
        mkdir -p m4
        if [ -f mono/mini/Makefile.am ]; then
          substituteInPlace mono/mini/Makefile.am \
            --replace-fail '`date`' 'Tue Jan  1 12:00:00 AM UTC 1980'
        fi
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
    };

    mono-2_11_4 = mkMono {
      version = "2.11.4";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "417ec7840f3f9195b03115f0c8c25aaa646a5b04";
        hash = "sha256-/WZAUoVQqJuy86bv+Q1Z5Ebsm1BPQoCuq3JtJaKLS3g=";
        fetchSubmodules = false;
      };
      # Adapted from Guix: the generic isinf fix is handled in mono.nix, and
      # this adds a GCC keyword compatibility fix not present in Guix.
      patches = [ ./patches/mono-2.11.4-fixes.patch ];
      bootstrapCompiler = self.mono-2_6_4;
      bootstrapRuntime = self.mono-2_6_4;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [ "--with-gc=boehm" ];
      makeFlags = [ "V=1" ];
      enableParallelBuilding = true;
      doCheck = false;
      patchReflectionFormatStrings = false;
      extraPostPatch = ''
        mkdir -p m4 external
        ${copyExternalRepos {
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "1836deff6a2683b8a5b7dd78f2b591a10b47573e"
              "sha256-k5Ahwb24b3H+MjTLR4HlSEseMYYJ5KwkpV6aiWIhGG8=";
          cecil =
            fetchMonoExternal "cecil" "54e0a50464edbc254b39ea3c885ee91ada730705"
              "sha256-04s++I2Y/hWtk4/SP8f/PJurzm2clmTQQJgEVdz6+gA=";
          entityframework =
            fetchMonoExternal "entityframework" "9baca562ee3a747a41870f45e749e4436b6aca26"
              "sha256-qpWdUFSZjukn4O4keb5XxCPfEfwQ/StwmSuv6RcBE1E=";
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
        }}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        if [ -f mono/mini/Makefile.am ]; then
          substituteInPlace mono/mini/Makefile.am \
            --replace-fail '`date`' 'Tue Jan  1 12:00:00 AM UTC 1980'
        fi
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
    };

    mono-3_0_12 = mkMono {
      version = "3.0.12";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "d6c5db881b26fd0f8ef64a65eba00e72fda552a2";
        hash = "sha256-kobOKOxHJknsa3vU/YhwKbJGcStayZdXX2bO6BgcDoQ=";
        fetchSubmodules = false;
      };
      bootstrapCompiler = self.mono-2_11_4;
      bootstrapRuntime = self.mono-2_11_4;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [ "--with-gc=boehm" ];
      makeFlags = [ "V=1" ];
      enableParallelBuilding = true;
      doCheck = false;
      patchReflectionFormatStrings = false;
      extraPostPatch = ''
        mkdir -p m4 external
        for dir in mono/metadata mono/mini; do
          if [ ! -f "$dir/Makefile.am" ] && [ -f "$dir/Makefile.am.in" ]; then
            cp "$dir/Makefile.am.in" "$dir/Makefile.am"
          fi
        done
        substituteInPlace mono/mini/method-to-ir.c \
          --replace-fail 'create_magic_tls_access (MonoCompile *cfg, MonoClassField *tls_field, MonoInst **cached_tls_addr, MonoInst *thread_local)' \
                         'create_magic_tls_access (MonoCompile *cfg, MonoClassField *tls_field, MonoInst **cached_tls_addr, MonoInst *tls_ins)' \
          --replace-fail 'thread_local->dreg' 'tls_ins->dreg'
        ${copyExternalRepos {
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
              "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
          cecil =
            fetchMonoExternal "cecil" "54e0a50464edbc254b39ea3c885ee91ada730705"
              "sha256-04s++I2Y/hWtk4/SP8f/PJurzm2clmTQQJgEVdz6+gA=";
          entityframework =
            fetchMonoExternal "entityframework" "a5faddeca2bee08636f1b7b3af8389bd4119f4cd"
              "sha256-R6UsW6tu+hnwVL9tIJAZOCNenRWj+r+uSK1xbNy/BSw=";
          ikvm =
            fetchMonoExternal "ikvm-fork" "10b8312c8024111780ee382688cd4c8754b1f1ac"
              "sha256-1SaAUfNNvnN1G+j0TRLg7Fc2PFQh8bcFwXm7J19yvAg=";
          "Lucene.Net" =
            fetchMonoExternal "Lucene.Net" "88fb67b07621dfed054d8d75fd50672fb26349df"
              "sha256-E40lPQIUkY4cXBj5sO0CsQNlndm0b6vKy+lOeL7D3eU=";
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
          rx =
            fetchMonoExternal "rx" "17e8477b2cb8dd018d49a567526fe99fd2897857"
              "sha256-BG6pz7a0J7Wl3HYYoMlfQeWiWdtrO+PcNKpW4CTx3js=";
        }}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
    };

    mono-3_12_1 = mkMono {
      version = "3.12.1";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "4cb3f77b4bbf703b1cda59db2f5aee206e35d31a";
        hash = "sha256-DvgCxlDOL8u8kcAQdD3y84w9fF2Mna3ORjMYyJzNXQc=";
        fetchSubmodules = false;
      };
      bootstrapCompiler = self.mono-3_0_12;
      bootstrapRuntime = self.mono-3_0_12;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [ "--with-gc=boehm" ];
      makeFlags = [
        "SKIP_AOT=1"
        "V=1"
      ];
      # mcs/ class-library Makefile uses recursive sub-make to build dependent
      # libraries (System → System.Xml etc.); under `-j` two sub-makes can
      # enter the same dir and race on the .dll write. Force serial.
      enableParallelBuilding = false;
      doCheck = false;
      patchReflectionFormatStrings = false;
      extraPostPatch = ''
        mkdir -p m4 external
        for dir in mono/metadata mono/mini; do
          if [ ! -f "$dir/Makefile.am" ] && [ -f "$dir/Makefile.am.in" ]; then
            cp "$dir/Makefile.am.in" "$dir/Makefile.am"
          fi
        done
        substituteInPlace mono/mini/method-to-ir.c \
          --replace-fail 'create_magic_tls_access (MonoCompile *cfg, MonoClassField *tls_field, MonoInst **cached_tls_addr, MonoInst *thread_local)' \
                         'create_magic_tls_access (MonoCompile *cfg, MonoClassField *tls_field, MonoInst **cached_tls_addr, MonoInst *tls_ins)' \
          --replace-fail 'thread_local->dreg' 'tls_ins->dreg'
        ${copyExternalRepos {
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
              "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
          cecil =
            fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
              "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
          entityframework =
            fetchMonoExternal "entityframework" "a5faddeca2bee08636f1b7b3af8389bd4119f4cd"
              "sha256-R6UsW6tu+hnwVL9tIJAZOCNenRWj+r+uSK1xbNy/BSw=";
          ikdasm =
            fetchMonoExternal "ikdasm" "7ded4decb9c39446be634d42a575fda9bc3d945c"
              "sha256-1IQEYkkgcESxlJH/KnDZBX19LAd8iCClLXnX/qNbdTg=";
          ikvm =
            fetchMonoExternal "ikvm-fork" "22534de2098acbcf208f6b06836d122dab799e4b"
              "sha256-FCUDNPsGv+ZNsunsGva5E64WlJ25J70G1SQVpovnfsc=";
          "Lucene.Net" =
            fetchMonoExternal "Lucene.Net" "88fb67b07621dfed054d8d75fd50672fb26349df"
              "sha256-E40lPQIUkY4cXBj5sO0CsQNlndm0b6vKy+lOeL7D3eU=";
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
          rx =
            fetchMonoExternal "rx" "00c1aadf149334c694d2a5096983a84cf46221b8"
              "sha256-uE7E8XNEKeWll5rruFHQh+MKPHv4KhqEfGRNmzGoqlk=";
        }}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
      extraPreConfigure = ''
        export TZ=
      '';
    };

    mono-4_9_0 = mkMono {
      version = "4.9.0";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "5a3736606e6243d2c84d4df2cf35c284214b8cc4";
        hash = "sha256-A8av5X1bt86xl8coXesM34XhvXMbvN8giXFxrCaeE28=";
        fetchSubmodules = false;
      };
      patches = [ guixPatches."mono-4.9.0-fix-runtimemetadataversion.patch" ];
      bootstrapCompiler = self.mono-3_12_1;
      bootstrapRuntime = self.mono-3_12_1;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [
        "--with-sgen=yes"
        "--disable-boehm"
        "--with-csc=mcs"
      ];
      makeFlags = [ "V=1" ];
      enableParallelBuilding = false;
      doCheck = false;
      patchReflectionFormatStrings = false;
      extraPostPatch = ''
        mkdir -p m4 external
        if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
          cp mono/mini/Makefile.am.in mono/mini/Makefile.am
        fi
        substituteInPlace mono/mini/main.c \
          --replace-fail "mono_build_date = build_date;" "(void) build_date;"
        ${copyExternalRepos {
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
              "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
          boringssl =
            fetchMonoExternal "boringssl" "c06ac6b33d3e7442ad878488b9d1100127eff998"
              "sha256-7DdPAcy0IZDTwbIab18Osfd8xsD4c8acNDHBnUO8/6A=";
          buildtools =
            fetchMonoExternal "buildtools" "9b6ee8686be55a983d886938165b6206cda50772"
              "sha256-rTuCKcxXN+S+n5Ci3GB8S8t58SEGdlWtl7GyrbgeXGo=";
          cecil =
            fetchMonoExternal "cecil" "2b39856e80d8513f70bc3241ed05325b0de679ae"
              "sha256-tXVsJ/HKcoDTQ+JDAs7q/jHccnsD6bhZ3tAuk8Xoam8=";
          cecil-legacy =
            fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
              "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
          entityframework =
            fetchMonoExternal "entityframework" "a5faddeca2bee08636f1b7b3af8389bd4119f4cd"
              "sha256-R6UsW6tu+hnwVL9tIJAZOCNenRWj+r+uSK1xbNy/BSw=";
          ikdasm =
            fetchMonoExternal "ikdasm" "e4deabf61c11999f200dcea6f6d6b42474cc2131"
              "sha256-VkGCK6bMkCrchC9ezt1mowQzeWxbjTSkOPTY48FxK7s=";
          ikvm =
            fetchMonoExternal "ikvm-fork" "367864ef810859ae3ce652864233b35f2dd5fdbe"
              "sha256-/ZbBnNCGSGng+9XgELJ7HgBRd5j62xHWr0ATVddM6UU=";
          "Lucene.Net.Light" =
            fetchMonoExternal "Lucene.Net.Light" "85978b7eb94738f516824341213d5e94060f5284"
              "sha256-MXonEg7tutx2hgLoN4S0GxM2hQooMgel20CNKkpEITQ=";
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
          nuget-buildtasks = fetchgit {
            url = "https://github.com/mono/NuGet.BuildTasks.git";
            rev = "04bdab55d8de9edcf628694cfd2001561e8f8e60";
            hash = "sha256-5RycEC928dM5HODnYMpGgU78m2WEUEd5eVO32b3qdNo=";
          };
          nunit-lite = fetchgit {
            url = "https://github.com/mono/NUnitLite.git";
            rev = "4bc79a6da1f0ee538560b7e4d0caff46d3c86e4f";
            hash = "sha256-WBzxIgdE00xTVtTmJFd7WYqnf+SG/7IgsvkQLpe6riA=";
          };
          rx =
            fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
              "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
        }}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        substituteInPlace tools/monograph/Makefile.am \
          --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                         "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
        substituteInPlace mcs/class/reference-assemblies/Makefile \
          --replace-fail "../../../external/binary-reference-assemblies/v" "${self.mono-3_12_1}/lib/mono/"
        substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
          --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
      extraPreConfigure = ''
        export TZ=
      '';
    };

    mono-5_0_1 = mkMono {
      version = "5.0.1";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "cf6c12e5759720b714e7aaee9156d61ba27c1f7b";
        hash = "sha256-xaIj0nf8RWJdWvICwzIXQETE4jpucHy45h1dSVtb6Rc=";
        fetchSubmodules = false;
      };
      bootstrapCompiler = self.mono-4_9_0;
      bootstrapRuntime = self.mono-4_9_0;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [
        "--with-sgen=yes"
        "--disable-boehm"
        "--with-csc=mcs"
      ];
      makeFlags = [
        "SKIP_AOT=1"
        "V=1"
      ];
      enableParallelBuilding = false;
      doCheck = false;
      patchReflectionFormatStrings = false;
      cmakeForConfigure = cmake;
      extraPostPatch = ''
                mkdir -p m4 external
                if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
                  cp mono/mini/Makefile.am.in mono/mini/Makefile.am
                fi
                substituteInPlace mono/mini/main.c \
                  --replace-fail "mono_build_date = build_date;" "(void) build_date;"
                substituteInPlace mono/utils/mono-dl.h \
                  --replace-fail 'MonoDl*     mono_dl_open       (const char *name, int flags, char **error_msg) MONO_LLVM_INTERNAL;' \
                                 'MONO_API MonoDl* mono_dl_open (const char *name, int flags, char **error_msg);'
                substituteInPlace mono/metadata/metadata-internals.h \
                  --replace-fail 'void
        mono_loader_register_module (const char *name, MonoDl *module);' \
                                 'MONO_API void
        mono_loader_register_module (const char *name, MonoDl *module);'
                substituteInPlace mono/btls/Makefile.am \
                  --replace-fail '-D SRC_DIR:PATH=$(abs_top_srcdir)/mono/btls -D BTLS_CFLAGS:STRING="$(BTLS_CFLAGS)"' \
                                 '-D SRC_DIR:PATH=$(abs_top_srcdir)/mono/btls -D BTLS_CFLAGS:STRING="$(BTLS_CFLAGS)" -D CMAKE_POLICY_VERSION_MINIMUM=3.5'
                ${copyExternalRepos {
                  aspnetwebstack =
                    fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
                      "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
                  binary-reference-assemblies =
                    fetchMonoExternal "reference-assemblies" "febc100f0313f0dc9d75dd1bcea45e87134b5b55"
                      "sha256-xBsqhdTezq77xduh3o5w0xPvBIjE3yZEHgJTUUNI8lI=";
                  bockbuild =
                    fetchMonoExternal "bockbuild" "512ba41a94bec35ff0c395eb71a180fda23da95c"
                      "sha256-b6lWIAoL0Yon4qP4b0c7eDGA7+qf+K4P2KhvjRQFoJo=";
                  boringssl =
                    fetchMonoExternal "boringssl" "c06ac6b33d3e7442ad878488b9d1100127eff998"
                      "sha256-7DdPAcy0IZDTwbIab18Osfd8xsD4c8acNDHBnUO8/6A=";
                  buildtools =
                    fetchMonoExternal "buildtools" "9b6ee8686be55a983d886938165b6206cda50772"
                      "sha256-rTuCKcxXN+S+n5Ci3GB8S8t58SEGdlWtl7GyrbgeXGo=";
                  cecil =
                    fetchMonoExternal "cecil" "7801534de1bfed97c844821c3244e05fc7ffcfb8"
                      "sha256-69SIRUEf2nEdIwumFSfVoRP0yHfOdErfosOeUuf3rjY=";
                  cecil-legacy =
                    fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
                      "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
                  corefx =
                    fetchMonoExternal "corefx" "bd96ae5f1485ae8541fe476dfd944efde76bcd9c"
                      "sha256-8asdv2eWYRV6dK3cVXSYNDR2iXRyC2W/I4rXRgqjoUg=";
                  corert =
                    fetchMonoExternal "corert" "d87c966d80c1274373ddafe3375bf1730cd430ed"
                      "sha256-zuP6KNlkysNc7hLlAyHEYVspyEyhm+RgeKLaePQsGx0=";
                  ikdasm =
                    fetchMonoExternal "ikdasm" "e4deabf61c11999f200dcea6f6d6b42474cc2131"
                      "sha256-VkGCK6bMkCrchC9ezt1mowQzeWxbjTSkOPTY48FxK7s=";
                  ikvm =
                    fetchMonoExternal "ikvm-fork" "367864ef810859ae3ce652864233b35f2dd5fdbe"
                      "sha256-/ZbBnNCGSGng+9XgELJ7HgBRd5j62xHWr0ATVddM6UU=";
                  linker =
                    fetchMonoExternal "linker" "e4d9784ac37b9ebf4757175c92bc7a3ec9fd867a"
                      "sha256-dEvHWOP0ZGk17UJQa2gFhoG2eFyz2SbEZ143TFNeRz0=";
                  "Lucene.Net.Light" =
                    fetchMonoExternal "Lucene.Net.Light" "85978b7eb94738f516824341213d5e94060f5284"
                      "sha256-MXonEg7tutx2hgLoN4S0GxM2hQooMgel20CNKkpEITQ=";
                  "Newtonsoft.Json" =
                    fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
                      "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
                  nuget-buildtasks = fetchgit {
                    url = "https://github.com/mono/NuGet.BuildTasks.git";
                    rev = "8d307472ea214f2b59636431f771894dbcba7258";
                    hash = "sha256-UtIWVbfCnSP+JaVwCV/V9dININNREhaTWGeiDqTNLsA=";
                  };
                  nunit-lite = fetchgit {
                    url = "https://github.com/mono/NUnitLite.git";
                    rev = "690603bea98aae69fca9a65130d88591bc6cabee";
                    hash = "sha256-jD9bxexVanJ+BxQtO135BJE+bTOGc89ean7oL7UvBLk=";
                  };
                  rx =
                    fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
                      "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
                }}
                find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
                substituteInPlace tools/monograph/Makefile.am \
                  --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                                 "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
                substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
                  --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
                substituteInPlace mcs/packages/Makefile \
                  --replace-fail "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
                if [ -f eglib/autogen.sh ]; then
                  patchShebangs eglib/autogen.sh
                fi
                if [ -d mcs/tools ]; then
                  patchShebangs mcs/tools
                fi
      '';
      extraPreConfigure = ''
        export TZ=
      '';
      extraPostBuild = ''
        pushd external/binary-reference-assemblies
        for makefile in $(find . -name Makefile); do
          substituteInPlace "$makefile" \
            --replace-quiet "CSC_COMMON_ARGS := " "CSC_COMMON_ARGS := -delaysign+ " \
            --replace-quiet "IBM.Data.DB2_REFS := " "IBM.Data.DB2_REFS := System.Xml " \
            --replace-quiet "Mono.Data.Sqlite_REFS := " "Mono.Data.Sqlite_REFS := System.Xml " \
            --replace-quiet "System.Data.DataSetExtensions_REFS := " "System.Data.DataSetExtensions_REFS := System.Xml " \
            --replace-quiet "System.Data.OracleClient_REFS := " "System.Data.OracleClient_REFS := System.Xml " \
            --replace-quiet "System.IdentityModel_REFS := " "System.IdentityModel_REFS := System.Configuration " \
            --replace-quiet "System.Design_REFS := " "System.Design_REFS := Accessibility " \
            --replace-quiet "System.Web.Extensions.Design_REFS := " "System.Web.Extensions.Design_REFS := System.Windows.Forms System.Web " \
            --replace-quiet "System.ServiceModel.Routing_REFS := " "System.ServiceModel.Routing_REFS := System.Xml " \
            --replace-quiet "System.Web.Abstractions_REFS := " "System.Web.Abstractions_REFS := System " \
            --replace-quiet "System.Reactive.Windows.Forms_REFS := " "System.Reactive.Windows.Forms_REFS := System " \
            --replace-quiet "System.Windows.Forms.DataVisualization_REFS := " "System.Windows.Forms.DataVisualization_REFS := Accessibility " \
            --replace-quiet "Facades/System.ServiceModel.Primitives_REFS := " "Facades/System.ServiceModel.Primitives_REFS := System.Xml " \
            --replace-quiet "Facades/System.Dynamic.Runtime_REFS := " "Facades/System.Dynamic.Runtime_REFS := System " \
            --replace-quiet "Facades/System.Xml.XDocument_REFS := " "Facades/System.Xml.XDocument_REFS := System.Xml " \
            --replace-quiet "Facades/System.Runtime.Serialization.Xml_REFS := " "Facades/System.Runtime.Serialization.Xml_REFS := System.Xml "
        done
        make -j"$NIX_BUILD_CORES" V=1 SKIP_AOT=1 \
          CSC="MONO_PATH=$PWD/../../mcs/class/lib/build $PWD/../../runtime/mono-wrapper $PWD/../../mcs/class/lib/build/mcs.exe"
        unset makefile
        popd
      '';
    };

    mono-5_1_0 = mkMono {
      version = "5.1.0";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "6fafd08b507c56f11a2eb6570703a39e5bdc0a81";
        hash = "sha256-ZYq+IyWp2l67xXdkM/CBwKcQc0TJ0rZchfAVrywguOs=";
        fetchSubmodules = false;
      };
      bootstrapCompiler = self.mono-5_0_1;
      bootstrapRuntime = self.mono-5_0_1;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [
        "--with-sgen=yes"
        "--disable-boehm"
        "--with-csc=mcs"
      ];
      makeFlags = [
        "SKIP_AOT=1"
        "V=1"
      ];
      enableParallelBuilding = false;
      doCheck = false;
      patchReflectionFormatStrings = false;
      cmakeForConfigure = cmake;
      extraPostPatch = ''
                mkdir -p m4 external
                if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
                  cp mono/mini/Makefile.am.in mono/mini/Makefile.am
                fi
                substituteInPlace mono/mini/main.c \
                  --replace-fail "mono_build_date = build_date;" "(void) build_date;"
                substituteInPlace mono/utils/mono-dl.h \
                  --replace-fail 'MonoDl*     mono_dl_open       (const char *name, int flags, char **error_msg) MONO_LLVM_INTERNAL;' \
                                 'MONO_API MonoDl* mono_dl_open (const char *name, int flags, char **error_msg);'
                substituteInPlace mono/metadata/metadata-internals.h \
                  --replace-fail 'void
        mono_loader_register_module (const char *name, MonoDl *module);' \
                                 'MONO_API void
        mono_loader_register_module (const char *name, MonoDl *module);'
                substituteInPlace mono/btls/Makefile.am \
                  --replace-fail '-D SRC_DIR:PATH=$(abs_top_srcdir)/mono/btls -D BTLS_CFLAGS:STRING="$(BTLS_CFLAGS)"' \
                                 '-D SRC_DIR:PATH=$(abs_top_srcdir)/mono/btls -D BTLS_CFLAGS:STRING="$(BTLS_CFLAGS)" -D CMAKE_POLICY_VERSION_MINIMUM=3.5'
                ${copyExternalRepos {
                  aspnetwebstack =
                    fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
                      "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
                  binary-reference-assemblies =
                    fetchMonoExternal "reference-assemblies" "febc100f0313f0dc9d75dd1bcea45e87134b5b55"
                      "sha256-xBsqhdTezq77xduh3o5w0xPvBIjE3yZEHgJTUUNI8lI=";
                  bockbuild =
                    fetchMonoExternal "bockbuild" "fd1d6c404d763c98b6f0e64e98ab65f92e808245"
                      "sha256-YPkncwENMgwE1/TbiieYjsmkwFqXSTcuBcIXOQxKVlA=";
                  boringssl =
                    fetchMonoExternal "boringssl" "c06ac6b33d3e7442ad878488b9d1100127eff998"
                      "sha256-7DdPAcy0IZDTwbIab18Osfd8xsD4c8acNDHBnUO8/6A=";
                  buildtools =
                    fetchMonoExternal "buildtools" "b5cc6e6ab5f71f6c0be7b730058b426e92528479"
                      "sha256-BlhZn9MA+U9aF4xyU9bWjJgI6sguWjBhSxJhcgktslE=";
                  cecil =
                    fetchMonoExternal "cecil" "44bc86223530a07fa74ab87007cf264e53d63400"
                      "sha256-jyBaeyueHq8c3M1Zyk9gTMLu1ZFQw+GnDT6BQyJSumo=";
                  cecil-legacy =
                    fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
                      "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
                  corefx =
                    fetchMonoExternal "corefx" "63c51e726292149b4868db71baa883e5ad173766"
                      "sha256-6VmwciurTpaLqsRganxCMPjIHcNOW9sEf2YOpPLKBpA=";
                  corert =
                    fetchMonoExternal "corert" "31eda261991f9f6c1add1686b6d3799f835b2978"
                      "sha256-+yOaNaRAo+hp18AN5/4WzcexhMOwOTREpx0ckCppF2g=";
                  ikdasm =
                    fetchMonoExternal "ikdasm" "88b67c42ca8b7d58141c176b46749819bfcef166"
                      "sha256-XHG6u9szp9YokE72T2xCYobYJ+cKx4AsICYD9GALCyw=";
                  ikvm =
                    fetchMonoExternal "ikvm-fork" "7c1e61bec8c069b2cc9e214c3094b147d76bbf82"
                      "sha256-1v0Jn0GWmBou8aBRhv6hAQba7k3mBB0/aROaI0kurG4=";
                  linker = fetchgit {
                    url = "https://github.com/mono/linker.git";
                    rev = "1bdcf6b7bfbe3b03fdaa76f6124d0d7374f08615";
                    hash = "sha256-cwg7Q+FF1Q48mYjunTfSiZkg62PwP7z9AOizxxrSpvc=";
                    fetchSubmodules = false;
                  };
                  "Lucene.Net.Light" =
                    fetchMonoExternal "Lucene.Net.Light" "85978b7eb94738f516824341213d5e94060f5284"
                      "sha256-MXonEg7tutx2hgLoN4S0GxM2hQooMgel20CNKkpEITQ=";
                  "Newtonsoft.Json" =
                    fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
                      "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
                  nuget-buildtasks = fetchgit {
                    url = "https://github.com/mono/NuGet.BuildTasks.git";
                    rev = "04bdab55d8de9edcf628694cfd2001561e8f8e60";
                    hash = "sha256-5RycEC928dM5HODnYMpGgU78m2WEUEd5eVO32b3qdNo=";
                  };
                  nunit-lite = fetchgit {
                    url = "https://github.com/mono/NUnitLite.git";
                    rev = "690603bea98aae69fca9a65130d88591bc6cabee";
                    hash = "sha256-jD9bxexVanJ+BxQtO135BJE+bTOGc89ean7oL7UvBLk=";
                  };
                  rx =
                    fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
                      "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
                }}
                find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
                substituteInPlace tools/monograph/Makefile.am \
                  --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                                 "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
                substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
                  --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
                substituteInPlace mcs/packages/Makefile \
                  --replace-fail "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
                if [ -f eglib/autogen.sh ]; then
                  patchShebangs eglib/autogen.sh
                fi
                if [ -d mcs/tools ]; then
                  patchShebangs mcs/tools
                fi
      '';
      extraPreConfigure = ''
        export TZ=
      '';
      extraPostBuild = ''
        pushd external/binary-reference-assemblies
        for makefile in $(find . -name Makefile); do
          substituteInPlace "$makefile" \
            --replace-quiet "CSC_COMMON_ARGS := " "CSC_COMMON_ARGS := -delaysign+ " \
            --replace-quiet "IBM.Data.DB2_REFS := " "IBM.Data.DB2_REFS := System.Xml " \
            --replace-quiet "Mono.Data.Sqlite_REFS := " "Mono.Data.Sqlite_REFS := System.Xml " \
            --replace-quiet "System.Data.DataSetExtensions_REFS := " "System.Data.DataSetExtensions_REFS := System.Xml " \
            --replace-quiet "System.Data.OracleClient_REFS := " "System.Data.OracleClient_REFS := System.Xml " \
            --replace-quiet "System.IdentityModel_REFS := " "System.IdentityModel_REFS := System.Configuration " \
            --replace-quiet "System.Design_REFS := " "System.Design_REFS := Accessibility " \
            --replace-quiet "System.Web.Extensions.Design_REFS := " "System.Web.Extensions.Design_REFS := System.Windows.Forms System.Web " \
            --replace-quiet "System.ServiceModel.Routing_REFS := " "System.ServiceModel.Routing_REFS := System.Xml " \
            --replace-quiet "System.Web.Abstractions_REFS := " "System.Web.Abstractions_REFS := System " \
            --replace-quiet "System.Reactive.Windows.Forms_REFS := " "System.Reactive.Windows.Forms_REFS := System " \
            --replace-quiet "System.Windows.Forms.DataVisualization_REFS := " "System.Windows.Forms.DataVisualization_REFS := Accessibility " \
            --replace-quiet "Facades/System.ServiceModel.Primitives_REFS := " "Facades/System.ServiceModel.Primitives_REFS := System.Xml " \
            --replace-quiet "Facades/System.Dynamic.Runtime_REFS := " "Facades/System.Dynamic.Runtime_REFS := System " \
            --replace-quiet "Facades/System.Xml.XDocument_REFS := " "Facades/System.Xml.XDocument_REFS := System.Xml " \
            --replace-quiet "Facades/System.Runtime.Serialization.Xml_REFS := " "Facades/System.Runtime.Serialization.Xml_REFS := System.Xml "
        done
        make -j"$NIX_BUILD_CORES" V=1 SKIP_AOT=1 \
          CSC="MONO_PATH=$PWD/../../mcs/class/lib/build $PWD/../../runtime/mono-wrapper $PWD/../../mcs/class/lib/build/mcs.exe"
        unset makefile
        popd
        make -C mcs/tools/resx2sr SKIP_AOT=1 V=1
      '';
      extraPostInstall = ''
                make -C mcs/tools/resx2sr install SKIP_AOT=1 V=1
                cat > "$out/bin/resx2sr" <<EOF
        #!/bin/sh
        exec "$out/bin/mono" "$out/lib/mono/4.5/resx2sr.exe" "\$@"
        EOF
                chmod +x "$out/bin/resx2sr"
      '';
    };

    mono-5_2_0 = mkMono {
      version = "5.2.0.224";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "mono-5.2.0.224";
        hash = "sha256-yi3G2gHDYTFwOGR7tmkvVzLOsPcY7rdfAT3eKT12T38=";
        fetchSubmodules = false;
      };
      bootstrapCompiler = self.mono-5_1_0;
      bootstrapRuntime = self.mono-5_1_0;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [
        "--with-sgen=yes"
        "--disable-boehm"
        "--with-csc=mcs"
      ];
      makeFlags = [
        "SKIP_AOT=1"
        "V=1"
      ];
      enableParallelBuilding = false;
      doCheck = false;
      patchReflectionFormatStrings = false;
      cmakeForConfigure = cmake;
      extraPostPatch = ''
                mkdir -p m4 external
                if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
                  cp mono/mini/Makefile.am.in mono/mini/Makefile.am
                fi
                substituteInPlace mono/mini/main.c \
                  --replace-fail "mono_build_date = build_date;" "(void) build_date;"
                substituteInPlace mono/utils/mono-dl.h \
                  --replace-fail 'MonoDl*     mono_dl_open       (const char *name, int flags, char **error_msg) MONO_LLVM_INTERNAL;' \
                                 'MONO_API MonoDl* mono_dl_open (const char *name, int flags, char **error_msg);'
                substituteInPlace mono/metadata/metadata-internals.h \
                  --replace-fail 'void
        mono_loader_register_module (const char *name, MonoDl *module);' \
                                 'MONO_API void
        mono_loader_register_module (const char *name, MonoDl *module);'
                substituteInPlace mono/btls/Makefile.am \
                  --replace-fail '-D SRC_DIR:PATH=$(abs_top_srcdir)/mono/btls -D BTLS_CFLAGS:STRING="$(BTLS_CFLAGS)"' \
                                 '-D SRC_DIR:PATH=$(abs_top_srcdir)/mono/btls -D BTLS_CFLAGS:STRING="$(BTLS_CFLAGS)" -D CMAKE_POLICY_VERSION_MINIMUM=3.5'
                ${copyExternalRepos {
                  aspnetwebstack =
                    fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
                      "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
                  binary-reference-assemblies =
                    fetchMonoExternal "reference-assemblies" "142cbeb62ffabf1dd9c1414d8dd76f93bcbed0c2"
                      "sha256-qSkuxIUiAsEJhRtJGZTy2funTlk+3bp/qSasBxMqbfI=";
                  bockbuild =
                    fetchMonoExternal "bockbuild" "45aa142fa322f5b41051e7f40008f03346a1e119"
                      "sha256-QCjblbeteVx+6A8+r5x9Agd2wOk3qCTODEVgOOB/VOo=";
                  boringssl =
                    fetchMonoExternal "boringssl" "3e0770e18835714708860ba9fe1af04a932971ff"
                      "sha256-3rxa7em96fHVzPIjNHOQano8P1XRKGuymKKokOgDKo0=";
                  buildtools =
                    fetchMonoExternal "buildtools" "b5cc6e6ab5f71f6c0be7b730058b426e92528479"
                      "sha256-BlhZn9MA+U9aF4xyU9bWjJgI6sguWjBhSxJhcgktslE=";
                  cecil =
                    fetchMonoExternal "cecil" "362e2bb00fa693d04c2d140a4cd313eb82c78d95"
                      "sha256-bbP73NVPfjDBv2TqUjcoqYA/x3jLmNUjUjI3aulWai8=";
                  cecil-legacy =
                    fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
                      "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
                  corefx =
                    fetchMonoExternal "corefx" "78360b22e71b70de1d8cc9588cb4ef0040449c31"
                      "sha256-p2LmU+A+6EpXr5+JGuO4pDSyTOvIqOUaC/hk5Z36OvM=";
                  corert =
                    fetchMonoExternal "corert" "ed6296dfbb88d66f08601c013caee30c88c41afa"
                      "sha256-ubc4xwV8vez024UHE8xlZaDueTQV9/Ama38RgqMKOJ0=";
                  ikdasm =
                    fetchMonoExternal "ikdasm" "88b67c42ca8b7d58141c176b46749819bfcef166"
                      "sha256-XHG6u9szp9YokE72T2xCYobYJ+cKx4AsICYD9GALCyw=";
                  ikvm =
                    fetchMonoExternal "ikvm-fork" "7c1e61bec8c069b2cc9e214c3094b147d76bbf82"
                      "sha256-1v0Jn0GWmBou8aBRhv6hAQba7k3mBB0/aROaI0kurG4=";
                  linker = fetchgit {
                    url = "https://github.com/mono/linker.git";
                    rev = "c7450ca2669becddffdea7dcdcc06692e57989e1";
                    hash = "sha256-YdfCSdKcO2xhIHJPFYnLk+VObLrpAFOPCDdUDA3foW0=";
                    fetchSubmodules = false;
                  };
                  "Lucene.Net.Light" =
                    fetchMonoExternal "Lucene.Net.Light" "85978b7eb94738f516824341213d5e94060f5284"
                      "sha256-MXonEg7tutx2hgLoN4S0GxM2hQooMgel20CNKkpEITQ=";
                  "Newtonsoft.Json" =
                    fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
                      "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
                  nuget-buildtasks = fetchgit {
                    url = "https://github.com/mono/NuGet.BuildTasks.git";
                    rev = "8d307472ea214f2b59636431f771894dbcba7258";
                    hash = "sha256-UtIWVbfCnSP+JaVwCV/V9dININNREhaTWGeiDqTNLsA=";
                  };
                  nunit-lite = fetchgit {
                    url = "https://github.com/mono/NUnitLite.git";
                    rev = "690603bea98aae69fca9a65130d88591bc6cabee";
                    hash = "sha256-jD9bxexVanJ+BxQtO135BJE+bTOGc89ean7oL7UvBLk=";
                  };
                  rx =
                    fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
                      "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
                }}
                find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
                substituteInPlace tools/monograph/Makefile.am \
                  --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                                 "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
                substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
                  --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
                substituteInPlace mcs/packages/Makefile \
                  --replace-fail "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
                if [ -f eglib/autogen.sh ]; then
                  patchShebangs eglib/autogen.sh
                fi
                if [ -d mcs/tools ]; then
                  patchShebangs mcs/tools
                fi
      '';
      extraPreConfigure = ''
        export TZ=
      '';
      extraPostBuild = ''
        pushd external/binary-reference-assemblies
        for makefile in $(find . -name Makefile); do
          substituteInPlace "$makefile" \
            --replace-quiet "CSC_COMMON_ARGS := " "CSC_COMMON_ARGS := -delaysign+ " \
            --replace-quiet "IBM.Data.DB2_REFS := " "IBM.Data.DB2_REFS := System.Xml " \
            --replace-quiet "Mono.Data.Sqlite_REFS := " "Mono.Data.Sqlite_REFS := System.Xml " \
            --replace-quiet "System.Data.DataSetExtensions_REFS := " "System.Data.DataSetExtensions_REFS := System.Xml " \
            --replace-quiet "System.Data.OracleClient_REFS := " "System.Data.OracleClient_REFS := System.Xml " \
            --replace-quiet "System.IdentityModel_REFS := " "System.IdentityModel_REFS := System.Configuration " \
            --replace-quiet "System.Design_REFS := " "System.Design_REFS := Accessibility " \
            --replace-quiet "System.Web.Extensions.Design_REFS := " "System.Web.Extensions.Design_REFS := System.Windows.Forms System.Web " \
            --replace-quiet "System.ServiceModel.Routing_REFS := " "System.ServiceModel.Routing_REFS := System.Xml " \
            --replace-quiet "System.Web.Abstractions_REFS := " "System.Web.Abstractions_REFS := System " \
            --replace-quiet "System.Reactive.Windows.Forms_REFS := " "System.Reactive.Windows.Forms_REFS := System " \
            --replace-quiet "System.Windows.Forms.DataVisualization_REFS := " "System.Windows.Forms.DataVisualization_REFS := Accessibility " \
            --replace-quiet "Facades/System.ServiceModel.Primitives_REFS := " "Facades/System.ServiceModel.Primitives_REFS := System.Xml " \
            --replace-quiet "Facades/System.Dynamic.Runtime_REFS := " "Facades/System.Dynamic.Runtime_REFS := System " \
            --replace-quiet "Facades/System.Xml.XDocument_REFS := " "Facades/System.Xml.XDocument_REFS := System.Xml " \
            --replace-quiet "Facades/System.Runtime.Serialization.Xml_REFS := " "Facades/System.Runtime.Serialization.Xml_REFS := System.Xml "
        done
        make -j"$NIX_BUILD_CORES" V=1 SKIP_AOT=1 \
          CSC="MONO_PATH=$PWD/../../mcs/class/lib/build $PWD/../../runtime/mono-wrapper $PWD/../../mcs/class/lib/build/mcs.exe"
        unset makefile
        popd
        make -C mcs/tools/resx2sr SKIP_AOT=1 V=1
      '';
      extraPostInstall = ''
                make -C mcs/tools/resx2sr install SKIP_AOT=1 V=1
                cat > "$out/bin/resx2sr" <<EOF
        #!/bin/sh
        exec "$out/bin/mono" "$out/lib/mono/4.5/resx2sr.exe" "\$@"
        EOF
                chmod +x "$out/bin/resx2sr"
      '';
    };

    mono-5_4_0 = mkMono {
      version = "5.4.0.212";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "mono-5.4.0.212";
        hash = "sha256-XliVpsDekaVysu+mSo6K6NT0thgb3njkdAVTHn53oz8=";
        fetchSubmodules = false;
      };
      patches = [ guixPatches."mono-5.4.0-patches.patch" ];
      bootstrapCompiler = self.mono-5_2_0;
      bootstrapRuntime = self.mono-5_2_0;
      cflags = baseCflagsWithIntConversion;
      configureFlags = [
        "--with-sgen=yes"
        "--disable-boehm"
        "--with-csc=mcs"
      ];
      makeFlags = [
        "SKIP_AOT=1"
        "V=1"
      ];
      enableParallelBuilding = false;
      doCheck = false;
      patchReflectionFormatStrings = false;
      cmakeForConfigure = cmake;
      extraPostPatch = ''
                mkdir -p m4 external
                if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
                  cp mono/mini/Makefile.am.in mono/mini/Makefile.am
                fi
                substituteInPlace mono/mini/main.c \
                  --replace-fail "mono_build_date = build_date;" "(void) build_date;"
                substituteInPlace mono/utils/mono-dl.h \
                  --replace-fail 'MonoDl*     mono_dl_open       (const char *name, int flags, char **error_msg) MONO_LLVM_INTERNAL;' \
                                 'MONO_API MonoDl* mono_dl_open (const char *name, int flags, char **error_msg);'
                substituteInPlace mono/metadata/metadata-internals.h \
                  --replace-fail 'void
        mono_loader_register_module (const char *name, MonoDl *module);' \
                                 'MONO_API void
        mono_loader_register_module (const char *name, MonoDl *module);'
                substituteInPlace mono/btls/Makefile.am \
                  --replace-fail '-D SRC_DIR:PATH=$(abs_top_srcdir)/mono/btls -D BTLS_CFLAGS:STRING="$(BTLS_CFLAGS)"' \
                                 '-D SRC_DIR:PATH=$(abs_top_srcdir)/mono/btls -D BTLS_CFLAGS:STRING="$(BTLS_CFLAGS)" -D CMAKE_POLICY_VERSION_MINIMUM=3.5'
                ${copyExternalRepos {
                  aspnetwebstack =
                    fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
                      "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
                  api-doc-tools = fetchgit {
                    url = "https://github.com/mono/api-doc-tools.git";
                    rev = "d03e819838c6241f92f90655cb448cc47c9e8791";
                    hash = "sha256-0g2nzdFL/goqfS6+oESyMADzW0Bax/1iZ+PF4dKJM+Y=";
                    fetchSubmodules = true;
                  };
                  api-snapshot =
                    fetchMonoExternal "api-snapshot" "b09033be33ab25113743151c644c831158c54042"
                      "sha256-k52pbX5MqVDdGf2OaUvM0Heaz810XjOiNSvmFRqOx3w=";
                  binary-reference-assemblies =
                    fetchMonoExternal "reference-assemblies" "142cbeb62ffabf1dd9c1414d8dd76f93bcbed0c2"
                      "sha256-qSkuxIUiAsEJhRtJGZTy2funTlk+3bp/qSasBxMqbfI=";
                  bockbuild =
                    fetchMonoExternal "bockbuild" "0efdb371e6d79abc54c0e3bb3689fa1646f4394e"
                      "sha256-O1vEgcU60kwahpjCFQqp8kWYCGYgmiBHFOsPxUUNGYM=";
                  boringssl =
                    fetchMonoExternal "boringssl" "3e0770e18835714708860ba9fe1af04a932971ff"
                      "sha256-3rxa7em96fHVzPIjNHOQano8P1XRKGuymKKokOgDKo0=";
                  cecil =
                    fetchMonoExternal "cecil" "c0eb983dac62519d3ae93a689312076aacecb723"
                      "sha256-s93gkWYHaB8Ycdti30hBA91HwYedV0fnBQAbpy6/Iwo=";
                  cecil-legacy =
                    fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
                      "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
                  corefx =
                    fetchMonoExternal "corefx" "9ad53d674e31327abcc60f35c14387700f50cc68"
                      "sha256-vJhGhdy2WDUwvYoWzminCh9DRZvNsLU7yUpzJJ145Co=";
                  corert =
                    fetchMonoExternal "corert" "48dba73801e804e89f00311da99d873f9c550278"
                      "sha256-c+tPJ1b9W9VvpTs5vgK5ihnXx4ldR+p7VBVzRpw8hP8=";
                  ikdasm =
                    fetchMonoExternal "ikdasm" "1d7d43603791e0236b56d076578657bee44fef6b"
                      "sha256-Tw897/mXDgQqdckQ9C/FNqp9asR7SfOugriUpub0iM8=";
                  ikvm =
                    fetchMonoExternal "ikvm-fork" "847e05fced5c9a41ff0f24f1f9d40d5a8a5772c1"
                      "sha256-8TqnNImacb6teF3HnnfjlRTm0p84kj42jsj9Skddibo=";
                  linker = fetchgit {
                    url = "https://github.com/mono/linker.git";
                    rev = "99354bf5c13b8055209cb082cddc50c8047ab088";
                    hash = "sha256-soYTaL3sn499xdoIrkTAuiBpKLYJQi7sdn0gh61U9Bc=";
                    fetchSubmodules = false;
                  };
                  "Newtonsoft.Json" =
                    fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
                      "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
                  nuget-buildtasks = fetchgit {
                    url = "https://github.com/mono/NuGet.BuildTasks.git";
                    rev = "b58ba4282377bcefd48abdc2d62ce6330e079abe";
                    hash = "sha256-d9PjUMACrDjE5RMegaaDlcii9PBWMfVP6lpObN0AXuk=";
                  };
                  nunit-lite = fetchgit {
                    url = "https://github.com/mono/NUnitLite.git";
                    rev = "690603bea98aae69fca9a65130d88591bc6cabee";
                    hash = "sha256-jD9bxexVanJ+BxQtO135BJE+bTOGc89ean7oL7UvBLk=";
                  };
                  rx =
                    fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
                      "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
                }}
                patch -d external/corefx -p1 < ${guixPatches."corefx-mono-5.4.0-patches.patch"}
                find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
                substituteInPlace tools/monograph/Makefile.am \
                  --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                                 "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
                substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
                  --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
                substituteInPlace mcs/packages/Makefile \
                  --replace-fail "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
                if [ -f eglib/autogen.sh ]; then
                  patchShebangs eglib/autogen.sh
                fi
                if [ -d mcs/tools ]; then
                  patchShebangs mcs/tools
                fi
      '';
      extraPreConfigure = ''
        export TZ=
      '';
      extraPostBuild = ''
        pushd external/binary-reference-assemblies
        for makefile in $(find . -name Makefile); do
          substituteInPlace "$makefile" \
            --replace-quiet "CSC_COMMON_ARGS := " "CSC_COMMON_ARGS := -delaysign+ " \
            --replace-quiet "IBM.Data.DB2_REFS := " "IBM.Data.DB2_REFS := System.Xml " \
            --replace-quiet "Mono.Data.Sqlite_REFS := " "Mono.Data.Sqlite_REFS := System.Xml " \
            --replace-quiet "System.Data.DataSetExtensions_REFS := " "System.Data.DataSetExtensions_REFS := System.Xml " \
            --replace-quiet "System.Data.OracleClient_REFS := " "System.Data.OracleClient_REFS := System.Xml " \
            --replace-quiet "System.IdentityModel_REFS := " "System.IdentityModel_REFS := System.Configuration " \
            --replace-quiet "System.Design_REFS := " "System.Design_REFS := Accessibility " \
            --replace-quiet "System.Web.Extensions.Design_REFS := " "System.Web.Extensions.Design_REFS := System.Windows.Forms System.Web " \
            --replace-quiet "System.ServiceModel.Routing_REFS := " "System.ServiceModel.Routing_REFS := System.Xml " \
            --replace-quiet "System.Web.Abstractions_REFS := " "System.Web.Abstractions_REFS := System " \
            --replace-quiet "System.Reactive.Windows.Forms_REFS := " "System.Reactive.Windows.Forms_REFS := System " \
            --replace-quiet "System.Windows.Forms.DataVisualization_REFS := " "System.Windows.Forms.DataVisualization_REFS := Accessibility " \
            --replace-quiet "Facades/System.ServiceModel.Primitives_REFS := " "Facades/System.ServiceModel.Primitives_REFS := System.Xml " \
            --replace-quiet "Facades/System.Dynamic.Runtime_REFS := " "Facades/System.Dynamic.Runtime_REFS := System " \
            --replace-quiet "Facades/System.Xml.XDocument_REFS := " "Facades/System.Xml.XDocument_REFS := System.Xml " \
            --replace-quiet "Facades/System.Runtime.Serialization.Xml_REFS := " "Facades/System.Runtime.Serialization.Xml_REFS := System.Xml "
        done
        make -j"$NIX_BUILD_CORES" V=1 SKIP_AOT=1 \
          CSC="MONO_PATH=$PWD/../../mcs/class/lib/build $PWD/../../runtime/mono-wrapper $PWD/../../mcs/class/lib/build/mcs.exe"
        unset makefile
        popd
        make -C mcs/tools/resx2sr SKIP_AOT=1 V=1
      '';
      extraPostInstall = ''
                if grep -q "NO_INSTALL = yes" mcs/tools/resx2sr/Makefile; then
                  substituteInPlace mcs/tools/resx2sr/Makefile \
                    --replace-fail "NO_INSTALL = yes" "# NO_INSTALL disabled for bootstrapping"
                fi
                make -C mcs/tools/resx2sr install SKIP_AOT=1 V=1
                cat > "$out/bin/resx2sr" <<EOF
        #!/bin/sh
        exec "$out/bin/mono" "$out/lib/mono/4.5/resx2sr.exe" "\$@"
        EOF
                chmod +x "$out/bin/resx2sr"
      '';
    };

    mono-pre-5_8_0 = self.mono-5_4_0.override {
      version = "5.4.0.201-0.d0f51b4e8340";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "d0f51b4e834042cfa593748ada942033b458cc40";
        hash = "sha256-o7BIrnczK83vb3qKJvKKBqeKR1i3rlljaS9ZG6bX5Ss=";
        fetchSubmodules = false;
      };
      patches = [ guixPatches."mono-5.4.0-patches.patch" ];
      bootstrapCompiler = self.mono-5_4_0;
      bootstrapRuntime = self.mono-5_4_0;
      extraPostPatch = ''
        mkdir -p m4 external
        if [ ! -f mono/mini/Makefile.am.in ] && [ -f mono/mini/Makefile.am ]; then
          cp mono/mini/Makefile.am mono/mini/Makefile.am.in
        fi
        if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
          cp mono/mini/Makefile.am.in mono/mini/Makefile.am
        fi
        if [ -f mono/mini/main.c ]; then
          if grep -q "mono_build_date = build_date;" mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail "mono_build_date = build_date;" "(void) build_date;"
          fi
          if grep -q '__DATE__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__DATE__' '"Jan 01 1980"'
          fi
          if grep -q '__TIME__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__TIME__' '"00:00:00"'
          fi
        fi
        if [ -f mono/utils/mono-dl.c ] && grep -q "void\* mono_dl_open" mono/utils/mono-dl.c; then
          substituteInPlace mono/utils/mono-dl.c \
            --replace-fail "void* mono_dl_open" "__attribute__((visibility(\"default\"))) void* mono_dl_open"
        fi
        if [ -f mono/metadata/loader.c ] && grep -q "void mono_loader_register_module" mono/metadata/loader.c; then
          substituteInPlace mono/metadata/loader.c \
            --replace-fail "void mono_loader_register_module" "__attribute__((visibility(\"default\"))) void mono_loader_register_module"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q -- "-DENABLE_ASSEMBLER=1" mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "-DENABLE_ASSEMBLER=1" "-DENABLE_ASSEMBLER=1 -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q "CMAKE_ARGS = " mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "CMAKE_ARGS = " "CMAKE_ARGS = -DCMAKE_POLICY_VERSION_MINIMUM=3.5 "
        fi
        ${copyExternalRepos {
          api-doc-tools = fetchgit {
            url = "https://github.com/mono/api-doc-tools.git";
            rev = "d03e819838c6241f92f90655cb448cc47c9e8791";
            hash = "sha256-0g2nzdFL/goqfS6+oESyMADzW0Bax/1iZ+PF4dKJM+Y=";
            fetchSubmodules = true;
          };
          api-snapshot =
            fetchMonoExternal "api-snapshot" "e790a9b77031ef1d8ebf093ef88840edea11ed73"
              "sha256-2HRV5NpNelp3tZe3t+dG5TJ1ve16oR5iYLemhp24lrA=";
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
              "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
          binary-reference-assemblies =
            fetchMonoExternal "reference-assemblies" "142cbeb62ffabf1dd9c1414d8dd76f93bcbed0c2"
              "sha256-qSkuxIUiAsEJhRtJGZTy2funTlk+3bp/qSasBxMqbfI=";
          bockbuild =
            fetchMonoExternal "bockbuild" "b445017309aac741a26d8c51bb0636234084bf23"
              "sha256-JZmUNfB640qhM6f9+crIK9cJtnyfKR68PhbI0Lba8Ms=";
          boringssl =
            fetchMonoExternal "boringssl" "3e0770e18835714708860ba9fe1af04a932971ff"
              "sha256-3rxa7em96fHVzPIjNHOQano8P1XRKGuymKKokOgDKo0=";
          cecil =
            fetchMonoExternal "cecil" "c76ba7b410447fa37093150cb7bc772cba28a0ae"
              "sha256-SH3TO51iedekeuOx9mZqD5NFKTnWP5Wk3R5LhWw+sXk=";
          cecil-legacy =
            fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
              "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
          corefx =
            fetchMonoExternal "corefx" "74ccd8aa00d7d271191ca3b9c4f818268dc36c28"
              "sha256-0miVkvuGvXtU+bg9T0iJocoa56kiOdsXysLIfRsOpFo=";
          corert =
            fetchMonoExternal "corert" "48dba73801e804e89f00311da99d873f9c550278"
              "sha256-c+tPJ1b9W9VvpTs5vgK5ihnXx4ldR+p7VBVzRpw8hP8=";
          ikdasm =
            fetchMonoExternal "ikdasm" "3aef9cdd6013fc0620a1817f0b11d8fb90ed2e0f"
              "sha256-+2u7hdqXziXmeEpUVS+Ll7uGV4Un8phMCoehPkZUDB0=";
          ikvm =
            fetchMonoExternal "ikvm-fork" "847e05fced5c9a41ff0f24f1f9d40d5a8a5772c1"
              "sha256-8TqnNImacb6teF3HnnfjlRTm0p84kj42jsj9Skddibo=";
          linker = fetchgit {
            url = "https://github.com/mono/linker.git";
            rev = "21e445c26c69ac3a2e1441befa02d0bd105ff849";
            hash = "sha256-jPt1/tGnT0XDdSgWEJMBgGJJRe2ySeQF0x6cp8GMo8M=";
            fetchSubmodules = false;
          };
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
          nuget-buildtasks = fetchgit {
            url = "https://github.com/mono/NuGet.BuildTasks.git";
            rev = "8d307472ea214f2b59636431f771894dbcba7258";
            hash = "sha256-UtIWVbfCnSP+JaVwCV/V9dININNREhaTWGeiDqTNLsA=";
          };
          nunit-lite = fetchgit {
            url = "https://github.com/mono/NUnitLite.git";
            rev = "690603bea98aae69fca9a65130d88591bc6cabee";
            hash = "sha256-jD9bxexVanJ+BxQtO135BJE+bTOGc89ean7oL7UvBLk=";
          };
          rx =
            fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
              "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
        }}
        patch -d external/corefx -p1 < ${guixPatches."corefx-mono-pre-5.8.0-patches.patch"}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        substituteInPlace tools/monograph/Makefile.am \
          --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                         "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
        substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
          --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
        substituteInPlace mcs/packages/Makefile \
          --replace-fail "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
    };

    mono-5_8_0 = self.mono-pre-5_8_0.override {
      version = "5.8.0.129";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "mono-5.8.0.129";
        hash = "sha256-5hMPi1bIw3Xzr/MuyVTtYp0nsOyJY3DK4eR+P0bbYAQ=";
        fetchSubmodules = false;
      };
      patches = [ guixPatches."mono-5.8.0-patches.patch" ];
      bootstrapCompiler = self.mono-pre-5_8_0;
      bootstrapRuntime = self.mono-pre-5_8_0;
      extraPostPatch = ''
        mkdir -p m4 external
        if [ ! -f mono/mini/Makefile.am.in ] && [ -f mono/mini/Makefile.am ]; then
          cp mono/mini/Makefile.am mono/mini/Makefile.am.in
        fi
        if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
          cp mono/mini/Makefile.am.in mono/mini/Makefile.am
        fi
        if [ -f mono/mini/main.c ]; then
          if grep -q "mono_build_date = build_date;" mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail "mono_build_date = build_date;" "(void) build_date;"
          fi
          if grep -q '__DATE__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__DATE__' '"Jan 01 1980"'
          fi
          if grep -q '__TIME__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__TIME__' '"00:00:00"'
          fi
        fi
        if [ -f mono/utils/mono-dl.c ] && grep -q "void\* mono_dl_open" mono/utils/mono-dl.c; then
          substituteInPlace mono/utils/mono-dl.c \
            --replace-fail "void* mono_dl_open" "__attribute__((visibility(\"default\"))) void* mono_dl_open"
        fi
        if [ -f mono/metadata/loader.c ] && grep -q "void mono_loader_register_module" mono/metadata/loader.c; then
          substituteInPlace mono/metadata/loader.c \
            --replace-fail "void mono_loader_register_module" "__attribute__((visibility(\"default\"))) void mono_loader_register_module"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q -- "-DENABLE_ASSEMBLER=1" mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "-DENABLE_ASSEMBLER=1" "-DENABLE_ASSEMBLER=1 -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q "CMAKE_ARGS = " mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "CMAKE_ARGS = " "CMAKE_ARGS = -DCMAKE_POLICY_VERSION_MINIMUM=3.5 "
        fi
        ${copyExternalRepos {
          api-doc-tools = fetchgit {
            url = "https://github.com/mono/api-doc-tools.git";
            rev = "d03e819838c6241f92f90655cb448cc47c9e8791";
            hash = "sha256-0g2nzdFL/goqfS6+oESyMADzW0Bax/1iZ+PF4dKJM+Y=";
            fetchSubmodules = true;
          };
          api-snapshot =
            fetchMonoExternal "api-snapshot" "6668c80a9499218c0b8cc41f48a9e242587df756"
              "sha256-7eiZxULDQQLnFXkEguAgGsWyx1yIDySOpJJkGBRffG0=";
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
              "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
          binary-reference-assemblies =
            fetchMonoExternal "reference-assemblies" "e048fe4a88d237d105ae02fe0363a68296099362"
              "sha256-iXjoopYNM10zzz6ud3TrdCEEFdjUUSc0esSRZPqIB0U=";
          bockbuild =
            fetchMonoExternal "bockbuild" "cb4545409dafe16dfe86c7d8e6548a69c369e2a2"
              "sha256-pz8b77+Ouz+KUBZGrK0rx+WbchIhzvdJ4/eaFsx2bWs=";
          boringssl =
            fetchMonoExternal "boringssl" "3e0770e18835714708860ba9fe1af04a932971ff"
              "sha256-3rxa7em96fHVzPIjNHOQano8P1XRKGuymKKokOgDKo0=";
          cecil =
            fetchMonoExternal "cecil" "76ffcdabae660e9586273c9b40db180a0dc8d4c8"
              "sha256-5BZK/IY1KnMtdGn3KNnJ+sla7SIHmAqWrf0iEbPTazg=";
          cecil-legacy =
            fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
              "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
          corefx =
            fetchMonoExternal "corefx" "b965d1f8b5281712c4400ef28ed97670ffd4880d"
              "sha256-WXPTNJ5+0JKPN+UY1zdWzDuZ6gyW4CsifmrIoRfIMGU=";
          corert =
            fetchMonoExternal "corert" "48dba73801e804e89f00311da99d873f9c550278"
              "sha256-c+tPJ1b9W9VvpTs5vgK5ihnXx4ldR+p7VBVzRpw8hP8=";
          ikdasm =
            fetchMonoExternal "ikdasm" "465c0815558fd43c0110f8d00fc186ac0044ac6a"
              "sha256-gpczTQGgto9ZLj8OqXIS1Kzrc8Oap4f0WZAA/Ng9OXY=";
          ikvm =
            fetchMonoExternal "ikvm-fork" "847e05fced5c9a41ff0f24f1f9d40d5a8a5772c1"
              "sha256-8TqnNImacb6teF3HnnfjlRTm0p84kj42jsj9Skddibo=";
          linker = fetchgit {
            url = "https://github.com/mono/linker.git";
            rev = "c62335c350f3902ff0459112f7efc8b926f4f15d";
            hash = "sha256-HUk1OlkzruQDlyHMYtq8zlrEbzGbeU2h3Scm3nRIoQQ=";
            fetchSubmodules = false;
          };
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
          nuget-buildtasks = fetchgit {
            url = "https://github.com/mono/NuGet.BuildTasks.git";
            rev = "b2c30bc81b2a7733a4eeb252a55f6b4d50cfc3a1";
            hash = "sha256-dL2D7QW8p5b8xXHlYrSovn6c7HI8tl5EcSJ4012Wagc=";
          };
          nunit-lite = fetchgit {
            url = "https://github.com/mono/NUnitLite.git";
            rev = "764656cdafdb3acd25df8cb52a4e0ea14760fccd";
            hash = "sha256-eAOuYiwLj7Uv8Xr6K/ce+9NK5cbqWWIZ0tGEdMekh10=";
          };
          rx =
            fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
              "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
        }}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        substituteInPlace tools/monograph/Makefile.am \
          --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                         "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
        substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
          --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
        substituteInPlace mcs/packages/Makefile \
          --replace-fail "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
      extraPostBuild = ''
        pushd external/binary-reference-assemblies
        for makefile in $(find . -name Makefile); do
          substituteInPlace "$makefile" \
            --replace-quiet "CSC_COMMON_ARGS := " "CSC_COMMON_ARGS := -delaysign+ " \
            --replace-quiet "IBM.Data.DB2_REFS := " "IBM.Data.DB2_REFS := System.Xml " \
            --replace-quiet "Mono.Data.Sqlite_REFS := " "Mono.Data.Sqlite_REFS := System.Xml " \
            --replace-quiet "System.Data.DataSetExtensions_REFS := " "System.Data.DataSetExtensions_REFS := System.Xml " \
            --replace-quiet "System.Data.OracleClient_REFS := " "System.Data.OracleClient_REFS := System.Xml " \
            --replace-quiet "System.IdentityModel_REFS := " "System.IdentityModel_REFS := System.Configuration " \
            --replace-quiet "System.Design_REFS := " "System.Design_REFS := Accessibility " \
            --replace-quiet "System.Web.Extensions.Design_REFS := " "System.Web.Extensions.Design_REFS := System.Windows.Forms System.Web " \
            --replace-quiet "System.ServiceModel.Routing_REFS := " "System.ServiceModel.Routing_REFS := System.Xml " \
            --replace-quiet "System.Web.Abstractions_REFS := " "System.Web.Abstractions_REFS := System " \
            --replace-quiet "System.Reactive.Windows.Forms_REFS := " "System.Reactive.Windows.Forms_REFS := System " \
            --replace-quiet "System.Windows.Forms.DataVisualization_REFS := " "System.Windows.Forms.DataVisualization_REFS := Accessibility " \
            --replace-quiet "Facades/System.ServiceModel.Primitives_REFS := " "Facades/System.ServiceModel.Primitives_REFS := System.Xml " \
            --replace-quiet "Facades/System.Dynamic.Runtime_REFS := " "Facades/System.Dynamic.Runtime_REFS := System " \
            --replace-quiet "Facades/System.Xml.XDocument_REFS := " "Facades/System.Xml.XDocument_REFS := System.Xml " \
            --replace-quiet "Facades/System.Runtime.Serialization.Xml_REFS := " "Facades/System.Runtime.Serialization.Xml_REFS := System.Xml " \
            --replace-quiet "Facades/System.Data.Common_REFS := " "Facades/System.Data.Common_REFS := System System.Xml "
        done
        make -j"$NIX_BUILD_CORES" V=1 SKIP_AOT=1 \
          CSC="MONO_PATH=$PWD/../../mcs/class/lib/build $PWD/../../runtime/mono-wrapper $PWD/../../mcs/class/lib/build/mcs.exe"
        unset makefile
        popd
        make -C mcs/tools/resx2sr SKIP_AOT=1 V=1
      '';
    };

    mono-pre-5_10_0 = self.mono-5_8_0.override {
      version = "5.8.0.129-0.3e9d7d6e9cf8";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "3e9d7d6e9cf8dc33eb29c497c350a1cd7df3a057";
        hash = "sha256-SxKKZJtWuqLJQEdKgM2hGbAwP0u7JK/1WM8B+N8HEVU=";
        fetchSubmodules = false;
      };
      patches = [ guixPatches."mono-mcs-patches-from-5.10.0.patch" ];
      bootstrapCompiler = self.mono-5_8_0;
      bootstrapRuntime = self.mono-5_8_0;
      extraPostPatch = ''
        mkdir -p m4 external
        if [ ! -f mono/mini/Makefile.am.in ] && [ -f mono/mini/Makefile.am ]; then
          cp mono/mini/Makefile.am mono/mini/Makefile.am.in
        fi
        if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
          cp mono/mini/Makefile.am.in mono/mini/Makefile.am
        fi
        if [ -f mono/mini/main.c ]; then
          if grep -q "mono_build_date = build_date;" mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail "mono_build_date = build_date;" "(void) build_date;"
          fi
          if grep -q '__DATE__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__DATE__' '"Jan 01 1980"'
          fi
          if grep -q '__TIME__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__TIME__' '"00:00:00"'
          fi
        fi
        if [ -f mono/utils/mono-dl.c ] && grep -q "void\* mono_dl_open" mono/utils/mono-dl.c; then
          substituteInPlace mono/utils/mono-dl.c \
            --replace-fail "void* mono_dl_open" "__attribute__((visibility(\"default\"))) void* mono_dl_open"
        fi
        if [ -f mono/metadata/loader.c ] && grep -q "void mono_loader_register_module" mono/metadata/loader.c; then
          substituteInPlace mono/metadata/loader.c \
            --replace-fail "void mono_loader_register_module" "__attribute__((visibility(\"default\"))) void mono_loader_register_module"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q -- "-DENABLE_ASSEMBLER=1" mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "-DENABLE_ASSEMBLER=1" "-DENABLE_ASSEMBLER=1 -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q "CMAKE_ARGS = " mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "CMAKE_ARGS = " "CMAKE_ARGS = -DCMAKE_POLICY_VERSION_MINIMUM=3.5 "
        fi
        ${copyExternalRepos {
          api-doc-tools = fetchgit {
            url = "https://github.com/mono/api-doc-tools.git";
            rev = "d03e819838c6241f92f90655cb448cc47c9e8791";
            hash = "sha256-0g2nzdFL/goqfS6+oESyMADzW0Bax/1iZ+PF4dKJM+Y=";
            fetchSubmodules = true;
          };
          api-snapshot =
            fetchMonoExternal "api-snapshot" "627333cae84f02a36ee9ca605c96dac4557d9f35"
              "sha256-tOHsAfozO7Oh0KoDqMoa0vUaKGiyFKe2R6Pz2PMyLF0=";
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
              "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
          binary-reference-assemblies =
            fetchMonoExternal "reference-assemblies" "9c5cc7f051a0bba2e41341a5baebfc4d2c2133ef"
              "sha256-4XFAVVqkthSbapIu68izRQ4vpZ9+Vy678w9Fu3GwbpE=";
          bockbuild =
            fetchMonoExternal "bockbuild" "29022af5d8a94651b2eece93f910559b254ec3f0"
              "sha256-hB+vygiw8MG9ADurtHuMrRHe6ziA0iYG70bmWnVglFE=";
          boringssl =
            fetchMonoExternal "boringssl" "3e0770e18835714708860ba9fe1af04a932971ff"
              "sha256-3rxa7em96fHVzPIjNHOQano8P1XRKGuymKKokOgDKo0=";
          cecil =
            fetchMonoExternal "cecil" "bc11f472954694ebd92ae4956f110c1036a7c2e0"
              "sha256-zfJlCpTY4wUaLEb35DdpV9VMO57YVmXkRYFbdsu1Vog=";
          cecil-legacy =
            fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
              "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
          corefx =
            fetchMonoExternal "corefx" "cb1b049c95227465c1791b857cb5ba86385d9f29"
              "sha256-o6y3M/eqVIU+qh8xRjlYj0I8umn4AfSC/sO4/qjEIN8=";
          corert =
            fetchMonoExternal "corert" "48dba73801e804e89f00311da99d873f9c550278"
              "sha256-c+tPJ1b9W9VvpTs5vgK5ihnXx4ldR+p7VBVzRpw8hP8=";
          ikdasm =
            fetchMonoExternal "ikdasm" "465c0815558fd43c0110f8d00fc186ac0044ac6a"
              "sha256-gpczTQGgto9ZLj8OqXIS1Kzrc8Oap4f0WZAA/Ng9OXY=";
          ikvm =
            fetchMonoExternal "ikvm-fork" "847e05fced5c9a41ff0f24f1f9d40d5a8a5772c1"
              "sha256-8TqnNImacb6teF3HnnfjlRTm0p84kj42jsj9Skddibo=";
          linker = fetchgit {
            url = "https://github.com/mono/linker.git";
            rev = "99354bf5c13b8055209cb082cddc50c8047ab088";
            hash = "sha256-soYTaL3sn499xdoIrkTAuiBpKLYJQi7sdn0gh61U9Bc=";
            fetchSubmodules = false;
          };
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
          nuget-buildtasks = fetchgit {
            url = "https://github.com/mono/NuGet.BuildTasks.git";
            rev = "b58ba4282377bcefd48abdc2d62ce6330e079abe";
            hash = "sha256-d9PjUMACrDjE5RMegaaDlcii9PBWMfVP6lpObN0AXuk=";
          };
          nunit-lite = fetchgit {
            url = "https://github.com/mono/NUnitLite.git";
            rev = "764656cdafdb3acd25df8cb52a4e0ea14760fccd";
            hash = "sha256-eAOuYiwLj7Uv8Xr6K/ce+9NK5cbqWWIZ0tGEdMekh10=";
          };
          rx =
            fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
              "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
        }}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        substituteInPlace tools/monograph/Makefile.am \
          --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                         "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
        substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
          --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
        substituteInPlace mcs/packages/Makefile \
          --replace-fail "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
    };

    mono-5_10_0 = self.mono-pre-5_10_0.override {
      version = "5.10.0.179";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "mono-5.10.0.179";
        hash = "sha256-RpgBURkrelpNN90JJa1qjCEggK+pegOmzr8STkxYcf8=";
        fetchSubmodules = false;
      };
      # Adapted from Guix: fragile nunit/csproj hunks are handled in
      # extraPostPatch below so they tolerate source layout and line ending
      # differences across this stage.
      patches = [ ./patches/mono-5.10.0-later-mcs-changes.patch ];
      bootstrapCompiler = self.mono-pre-5_10_0;
      bootstrapRuntime = self.mono-pre-5_10_0;
      extraNativeBuildInputs = [ python3 ];
      extraPostPatch = ''
        mkdir -p m4 external
        for file in \
          mcs/nunit24/ClientUtilities/util/AssemblyInfo.cs \
          mcs/nunit24/ConsoleRunner/nunit-console/AssemblyInfo.cs \
          mcs/nunit24/NUnitCore/core/AssemblyInfo.cs \
          mcs/nunit24/NUnitCore/interfaces/AssemblyInfo.cs \
          mcs/nunit24/NUnitExtensions/core/AssemblyInfo.cs \
          mcs/nunit24/NUnitExtensions/framework/AssemblyInfo.cs \
          mcs/nunit24/NUnitFramework/framework/AssemblyInfo.cs \
          mcs/nunit24/NUnitMocks/mocks/AssemblyInfo.cs; do
          if [ -f "$file" ]; then
            perl -0pi -e 's/\r?\n\[assembly: AssemblyDelaySign\(false\)\]\r?\n\[assembly: AssemblyKeyFile\("\.\.\/\.\.\/nunit\.snk"\)\]\r?\n\[assembly: AssemblyKeyName\(""\)\]//g' "$file"
          fi
        done
        if [ -f msvc/scripts/csproj.tmpl ] && ! grep -q "@METADATAVERSION@" msvc/scripts/csproj.tmpl; then
          perl -0pi -e 's/(    \@NOSTDLIB\@\r?\n)/$1    \@METADATAVERSION\@\n/' msvc/scripts/csproj.tmpl
        fi
        if [ ! -f mono/mini/Makefile.am.in ] && [ -f mono/mini/Makefile.am ]; then
          cp mono/mini/Makefile.am mono/mini/Makefile.am.in
        fi
        if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
          cp mono/mini/Makefile.am.in mono/mini/Makefile.am
        fi
        if [ -f mono/mini/main.c ]; then
          if grep -q "mono_build_date = build_date;" mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail "mono_build_date = build_date;" "(void) build_date;"
          fi
          if grep -q '__DATE__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__DATE__' '"Jan 01 1980"'
          fi
          if grep -q '__TIME__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__TIME__' '"00:00:00"'
          fi
        fi
        if [ -f mono/utils/mono-dl.c ] && grep -q "void\* mono_dl_open" mono/utils/mono-dl.c; then
          substituteInPlace mono/utils/mono-dl.c \
            --replace-fail "void* mono_dl_open" "__attribute__((visibility(\"default\"))) void* mono_dl_open"
        fi
        if [ -f mono/metadata/loader.c ] && grep -q "void mono_loader_register_module" mono/metadata/loader.c; then
          substituteInPlace mono/metadata/loader.c \
            --replace-fail "void mono_loader_register_module" "__attribute__((visibility(\"default\"))) void mono_loader_register_module"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q -- "-DENABLE_ASSEMBLER=1" mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "-DENABLE_ASSEMBLER=1" "-DENABLE_ASSEMBLER=1 -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q "CMAKE_ARGS = " mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "CMAKE_ARGS = " "CMAKE_ARGS = -DCMAKE_POLICY_VERSION_MINIMUM=3.5 "
        fi
        ${copyExternalRepos {
          api-doc-tools = fetchgit {
            url = "https://github.com/mono/api-doc-tools.git";
            rev = "d03e819838c6241f92f90655cb448cc47c9e8791";
            hash = "sha256-0g2nzdFL/goqfS6+oESyMADzW0Bax/1iZ+PF4dKJM+Y=";
            fetchSubmodules = true;
          };
          api-snapshot =
            fetchMonoExternal "api-snapshot" "da8bb8c7b970383ce26c9b09ce3689d843a6222e"
              "sha256-HPtR/d1cAWLQGvap9EhLW7a5DBwb6D3/ArDl6BPgfQI=";
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
              "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
          binary-reference-assemblies =
            fetchMonoExternal "reference-assemblies" "e048fe4a88d237d105ae02fe0363a68296099362"
              "sha256-iXjoopYNM10zzz6ud3TrdCEEFdjUUSc0esSRZPqIB0U=";
          bockbuild =
            fetchMonoExternal "bockbuild" "1908d43ec630544189bd11630a59ec4ef571db28"
              "sha256-Y4XMhsvv+tqkzx/WQi0AwQH7FJQQW1TYX5Y3weKjI8A=";
          boringssl =
            fetchMonoExternal "boringssl" "3e0770e18835714708860ba9fe1af04a932971ff"
              "sha256-3rxa7em96fHVzPIjNHOQano8P1XRKGuymKKokOgDKo0=";
          cecil =
            fetchMonoExternal "cecil" "dfee11e80d59e1a3d6d9c914c3f277c726bace52"
              "sha256-CAg8a6nmXna2mpsowD+qflLgaaIfRHwxpcIjlHYqTvg=";
          cecil-legacy =
            fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
              "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
          corefx =
            fetchMonoExternal "corefx" "e327d2855ed74dac96f684797e4820345297a690"
              "sha256-AKuIwhM60fkIqo3BWlrN/MA6sWcoSfdAhMTxj6y18YY=";
          corert =
            fetchMonoExternal "corert" "aa64b376c1a2238b1a768e158d1b11dac77d722a"
              "sha256-7/H93nmli0alCl9r8v6/vqSRj89K8mZS98VnoBOp5L0=";
          ikdasm =
            fetchMonoExternal "ikdasm" "465c0815558fd43c0110f8d00fc186ac0044ac6a"
              "sha256-gpczTQGgto9ZLj8OqXIS1Kzrc8Oap4f0WZAA/Ng9OXY=";
          ikvm =
            fetchMonoExternal "ikvm-fork" "847e05fced5c9a41ff0f24f1f9d40d5a8a5772c1"
              "sha256-8TqnNImacb6teF3HnnfjlRTm0p84kj42jsj9Skddibo=";
          linker = fetchgit {
            url = "https://github.com/mono/linker.git";
            rev = "84d37424cde6e66bbf997110a4dbdba7e60038e9";
            hash = "sha256-GR8CJM/q/snp8n+Sopfy/ekili7WBZbn2k1/GRObzh0=";
            fetchSubmodules = false;
          };
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
          nuget-buildtasks = fetchgit {
            url = "https://github.com/mono/NuGet.BuildTasks.git";
            rev = "b2c30bc81b2a7733a4eeb252a55f6b4d50cfc3a1";
            hash = "sha256-dL2D7QW8p5b8xXHlYrSovn6c7HI8tl5EcSJ4012Wagc=";
          };
          nunit-lite = fetchgit {
            url = "https://github.com/mono/NUnitLite.git";
            rev = "70bb70b0ffd0109aadaa6e4ea178972d4fb63ea3";
            hash = "sha256-mMBn3mDiIa9G2cjlhKGdll9mRROXaYZd5Y0Bk4LNx1I=";
          };
          rx =
            fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
              "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
        }}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        substituteInPlace tools/monograph/Makefile.am \
          --replace-fail "/mono/metadata/libmonoruntimesgen-static.la" \
                         "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
        substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
          --replace-fail "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
        substituteInPlace mcs/packages/Makefile \
          --replace-fail "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
      extraPreBuild = ''
        pushd external/binary-reference-assemblies
        for makefile in $(find . -name Makefile); do
          substituteInPlace "$makefile" \
            --replace-quiet "CSC_COMMON_ARGS := " "CSC_COMMON_ARGS := -delaysign+ " \
            --replace-quiet "IBM.Data.DB2_REFS := " "IBM.Data.DB2_REFS := System.Xml " \
            --replace-quiet "Mono.Data.Sqlite_REFS := " "Mono.Data.Sqlite_REFS := System.Xml " \
            --replace-quiet "System.Data.DataSetExtensions_REFS := " "System.Data.DataSetExtensions_REFS := System.Xml " \
            --replace-quiet "System.Data.OracleClient_REFS := " "System.Data.OracleClient_REFS := System.Xml " \
            --replace-quiet "System.IdentityModel_REFS := " "System.IdentityModel_REFS := System.Configuration " \
            --replace-quiet "System.Design_REFS := " "System.Design_REFS := Accessibility " \
            --replace-quiet "System.Web.Extensions.Design_REFS := " "System.Web.Extensions.Design_REFS := System.Windows.Forms System.Web " \
            --replace-quiet "System.ServiceModel.Routing_REFS := " "System.ServiceModel.Routing_REFS := System.Xml " \
            --replace-quiet "System.Web.Abstractions_REFS := " "System.Web.Abstractions_REFS := System " \
            --replace-quiet "System.Reactive.Windows.Forms_REFS := " "System.Reactive.Windows.Forms_REFS := System " \
            --replace-quiet "System.Windows.Forms.DataVisualization_REFS := " "System.Windows.Forms.DataVisualization_REFS := Accessibility " \
            --replace-quiet "Facades/System.ServiceModel.Primitives_REFS := " "Facades/System.ServiceModel.Primitives_REFS := System.Xml " \
            --replace-quiet "Facades/System.Dynamic.Runtime_REFS := " "Facades/System.Dynamic.Runtime_REFS := System " \
            --replace-quiet "Facades/System.Xml.XDocument_REFS := " "Facades/System.Xml.XDocument_REFS := System.Xml " \
            --replace-quiet "Facades/System.Runtime.Serialization.Xml_REFS := " "Facades/System.Runtime.Serialization.Xml_REFS := System.Xml " \
            --replace-quiet "Facades/System.Data.Common_REFS := " "Facades/System.Data.Common_REFS := System System.Xml "
        done
        make -j"$NIX_BUILD_CORES" V=1 SKIP_AOT=1 CSC=mcs
        unset makefile
        popd
      '';
      extraPostBuild = ''
        make -C mcs/tools/resx2sr SKIP_AOT=1 V=1
      '';
    };

    mono-6_12_0 = self.mono-5_10_0.override {
      version = "6.12.0.206";
      src = fetchgit {
        url = "https://gitlab.winehq.org/mono/mono.git";
        rev = "mono-6.12.0.206";
        hash = "sha256-c1NlEoa65yLQlKL/8MLXZtlovDkyllv72Yatt0bZibM=";
        fetchSubmodules = false;
      };
      patches = [
        guixPatches."mono-6.12.0-fix-ConditionParser.patch"
        # Adapted from Guix: the SectionGroupInfo runpath hunk is omitted.
        ./patches/mono-6.12.0-add-runpath.patch
        guixPatches."mono-6.12.0-fix-AssemblyResolver.patch"
      ];
      bootstrapCompiler = self.mono-5_10_0;
      bootstrapRuntime = self.mono-5_10_0;
      extraNativeBuildInputs = [ python3 ];
      extraBuildInputs = [
        libgdiplus
        unixodbc
      ];
      extraPostPatch = ''
        mkdir -p m4 external
        if [ -f mcs/build/common/basic-profile-check.cs ]; then
          perl -0pi -e 's/min_mono_version = new Version \([0-9]+, [0-9]+\);/min_mono_version = new Version (0, 0);/g' \
            mcs/build/common/basic-profile-check.cs
        fi
        if [ -f mono/mini/Makefile.am.in ]; then
          substituteInPlace mono/mini/Makefile.am.in \
            --replace-quiet "-langversion:8.0" ""
        fi
        if [ -f mono/tests/Makefile.am ]; then
          perl -0pi -e 's/\t(dim-generic|dim-issue-18917|interface-2|delegate18|generic-unmanaged-constraint|async-generic-enum)\.cs[^\n]*\n//g' mono/tests/Makefile.am
        fi
        if [ -f runtime/Makefile.am ]; then
          substituteInPlace runtime/Makefile.am \
            --replace-quiet "	    fi; done; done;" "	    fi; done; done; ok=:;"
        fi
        if [ -f mcs/tools/Makefile ]; then
          substituteInPlace mcs/tools/Makefile \
            --replace-quiet "mono-helix-client" ""
        fi
        if [ -f mcs/tools/resx2sr/Makefile ]; then
          substituteInPlace mcs/tools/resx2sr/Makefile \
            --replace-quiet "NO_INSTALL = yes" "NO_INSTALL ="
        fi
        if [ ! -f mono/mini/Makefile.am.in ] && [ -f mono/mini/Makefile.am ]; then
          cp mono/mini/Makefile.am mono/mini/Makefile.am.in
        fi
        if [ ! -f mono/mini/Makefile.am ] && [ -f mono/mini/Makefile.am.in ]; then
          cp mono/mini/Makefile.am.in mono/mini/Makefile.am
        fi
        if [ -f mono/mini/main.c ]; then
          if grep -q "mono_build_date = build_date;" mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail "mono_build_date = build_date;" "(void) build_date;"
          fi
          if grep -q '__DATE__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__DATE__' '"Jan 01 1980"'
          fi
          if grep -q '__TIME__' mono/mini/main.c; then
            substituteInPlace mono/mini/main.c \
              --replace-fail '__TIME__' '"00:00:00"'
          fi
        fi
        if [ -f mono/utils/mono-dl.c ] && grep -q "void\* mono_dl_open" mono/utils/mono-dl.c; then
          substituteInPlace mono/utils/mono-dl.c \
            --replace-fail "void* mono_dl_open" "__attribute__((visibility(\"default\"))) void* mono_dl_open"
        fi
        if [ -f mono/metadata/loader.c ] && grep -q "void mono_loader_register_module" mono/metadata/loader.c; then
          substituteInPlace mono/metadata/loader.c \
            --replace-fail "void mono_loader_register_module" "__attribute__((visibility(\"default\"))) void mono_loader_register_module"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q -- "-DENABLE_ASSEMBLER=1" mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "-DENABLE_ASSEMBLER=1" "-DENABLE_ASSEMBLER=1 -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        fi
        if [ -f mono/btls/Makefile.am ] && grep -q "CMAKE_ARGS = " mono/btls/Makefile.am; then
          substituteInPlace mono/btls/Makefile.am \
            --replace-fail "CMAKE_ARGS = " "CMAKE_ARGS = -DCMAKE_POLICY_VERSION_MINIMUM=3.5 "
        fi
        ${copyExternalRepos {
          api-doc-tools = fetchgit {
            url = "https://github.com/mono/api-doc-tools.git";
            rev = "5da8127af9e68c9d58a90aa9de21f57491d81261";
            hash = "sha256-5DFNne4mEMC4F9YPwymG36ChUQNmoiSaNWOr4mtvCGc=";
            fetchSubmodules = true;
          };
          api-snapshot =
            fetchMonoExternal "api-snapshot" "808e8a9e4be8d38e097d2b0919cac37bc195844a"
              "sha256-KgAyyc/3njVRqtnByygPQc1tGhQ4pRhxrysRw9uLtcQ=";
          aspnetwebstack =
            fetchMonoExternal "aspnetwebstack" "e77b12e6cc5ed260a98447f609e887337e44e299"
              "sha256-AbtgeY4xkkTJP03O0FBFZNQ6sWjEiKDduNWRjAkZemY=";
          binary-reference-assemblies =
            fetchMonoExternal "reference-assemblies" "e68046d5106aa0349c23f95821456955fc15b96b"
              "sha256-IJGbH8cek+cfeELP+BQ2jklVXf5qoW48QRQ2TI74F9c=";
          bockbuild =
            fetchMonoExternal "bockbuild" "3bd44f6784b85b1ece8b00b13d12cf416f5a87e7"
              "sha256-uku2DwztSEfVl/jXXZxjDxFhi3+66s0undRyRz1GbXw=";
          boringssl =
            fetchMonoExternal "boringssl" "296137cf989688b03ed89f72cd7bfd86d470441e"
              "sha256-yiHa7/RnSVOdevvMKwdZ5+UO0SFynWACtNpv5rxq8IU=";
          cecil =
            fetchMonoExternal "cecil" "8021f3fbe75715a1762e725594d8c00cce3679d8"
              "sha256-tVvPVO9gBzDsnrZKvNENVC1IdF8OTF/R78KDoRenKUg=";
          cecil-legacy =
            fetchMonoExternal "cecil" "33d50b874fd527118bc361d83de3d494e8bb55e1"
              "sha256-C3qp7SgHNmy4hLgDKOvZoFMgmaFWF+enN2JFk06gkNw=";
          corefx =
            fetchMonoExternal "corefx" "c4eeab9fc2faa0195a812e552cd73ee298d39386"
              "sha256-SONNnmv2GXEwZdk6l39FM6tFxk91oLVhpLi1ZtwFoww=";
          corert =
            fetchMonoExternal "corert" "11136ad55767485063226be08cfbd32ed574ca43"
              "sha256-DkWrTC838hfZ8hjrP9KeoPNf3ZmVOc3tGWIE59xAGLw=";
          helix-binaries =
            fetchMonoExternal "helix-binaries" "64b3a67631ac8a08ff82d61087cfbfc664eb4af8"
              "sha256-p7kZuUPBH+yhQNnKejOZk90LsPzTjAXDTX0N+ded07g=";
          ikdasm =
            fetchMonoExternal "ikdasm" "f0fd66ea063929ef5d51aafdb10832164835bb0f"
              "sha256-IKx/rCeOKUBBDUgq+lRfdjFnGjNNGjBWggFAWeu+Iww=";
          ikvm =
            fetchMonoExternal "ikvm-fork" "08266ac8c0b620cc929ffaeb1f23ac37629ce825"
              "sha256-W2Io+1u1DQ46oopwnU3FA/f6ZnIQe5z4wXz2bdEOG7w=";
          illinker-test-assets =
            fetchMonoExternal "illinker-test-assets" "ec9eb51af2eb07dbe50a2724db826bf3bfb930a6"
              "sha256-9BVEq116ACIvKAHo6ZaZ4t2rAy9WgOfcp4TatyTBm6w=";
          linker = fetchgit {
            url = "https://github.com/mono/linker.git";
            rev = "ed4a9413489aa29a70e41f94c3dac5621099f734";
            hash = "sha256-4knV2QCSrPwb6GGsy+VIPxNlf1KBkPgZtFlZlSC7LZs=";
            fetchSubmodules = false;
          };
          "Newtonsoft.Json" =
            fetchMonoExternal "Newtonsoft.Json" "471c3e0803a9f40a0acc8aeceb31de6ff93a52c4"
              "sha256-Gp1UpraahcFFXQanzr4Y1U7bsLFLTUAehd5MDEt79jU=";
          nuget-buildtasks = fetchgit {
            url = "https://github.com/mono/NuGet.BuildTasks.git";
            rev = "99558479578b1d6af0f443bb411bc3520fcbae5c";
            hash = "sha256-A1NHJ/P6gI9B+NKcRn0kisB6sY3RqJXi3Ossnb6pZJA=";
          };
          nunit-lite = fetchgit {
            url = "https://github.com/mono/NUnitLite.git";
            rev = "a977ca57572c545e108b56ef32aa3f7ff8287611";
            hash = "sha256-UhOOVt5A8bQanj42UhB5KFHsOP4Tkrs4pV9dxK9r/As=";
          };
          rx =
            fetchMonoExternal "rx" "b29a4b0fda609e0af33ff54ed13652b6ccf0e05e"
              "sha256-O/oioCocqVIG9xUl3wn4WZw1/2W1RgNQE5vNpSvkMtg=";
        }}
        find external -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete
        if [ -f tools/monograph/Makefile.am ]; then
          substituteInPlace tools/monograph/Makefile.am \
            --replace-quiet "/mono/metadata/libmonoruntimesgen-static.la" \
                            "/mono/metadata/libmonoruntimesgen-static.la \$(top_builddir)/mono/sgen/libmonosgen-static.la"
        fi
        if [ -f mcs/class/Microsoft.Build.Tasks/Makefile ]; then
          substituteInPlace mcs/class/Microsoft.Build.Tasks/Makefile \
            --replace-quiet "include ../../build/library.make" $'include ../../build/library.make\nrun-test-recursive:\n\t@echo skipping tests'
        fi
        if [ -f mcs/packages/Makefile ]; then
          substituteInPlace mcs/packages/Makefile \
            --replace-quiet "install-local:" $'install-local:\n\techo "Skipping blob install"\n\nunused0:'
        fi
        if [ -f eglib/autogen.sh ]; then
          patchShebangs eglib/autogen.sh
        fi
        if [ -d mcs/tools ]; then
          patchShebangs mcs/tools
        fi
      '';
      extraPreBuild = ''
        pushd external/binary-reference-assemblies
        for makefile in $(find . -name Makefile); do
          substituteInPlace "$makefile" \
            --replace-quiet "CSC_COMMON_ARGS := " "CSC_COMMON_ARGS := -delaysign+ " \
            --replace-quiet "IBM.Data.DB2_REFS := " "IBM.Data.DB2_REFS := System.Xml " \
            --replace-quiet "Mono.Data.Sqlite_REFS := " "Mono.Data.Sqlite_REFS := System.Xml " \
            --replace-quiet "System.Data.DataSetExtensions_REFS := " "System.Data.DataSetExtensions_REFS := System.Xml " \
            --replace-quiet "System.Data.OracleClient_REFS := " "System.Data.OracleClient_REFS := System.Xml " \
            --replace-quiet "System.IdentityModel_REFS := " "System.IdentityModel_REFS := System.Configuration " \
            --replace-quiet "System.Design_REFS := " "System.Design_REFS := Accessibility " \
            --replace-quiet "System.Web.Extensions.Design_REFS := " "System.Web.Extensions.Design_REFS := System.Windows.Forms System.Web " \
            --replace-quiet "System.ServiceModel.Routing_REFS := " "System.ServiceModel.Routing_REFS := System.Xml " \
            --replace-quiet "System.Web.Abstractions_REFS := " "System.Web.Abstractions_REFS := System " \
            --replace-quiet "System.Reactive.Windows.Forms_REFS := " "System.Reactive.Windows.Forms_REFS := System " \
            --replace-quiet "System.Windows.Forms.DataVisualization_REFS := " "System.Windows.Forms.DataVisualization_REFS := Accessibility " \
            --replace-quiet "Facades/System.ServiceModel.Primitives_REFS := " "Facades/System.ServiceModel.Primitives_REFS := System.Xml " \
            --replace-quiet "Facades/System.Dynamic.Runtime_REFS := " "Facades/System.Dynamic.Runtime_REFS := System " \
            --replace-quiet "Facades/System.Xml.XDocument_REFS := " "Facades/System.Xml.XDocument_REFS := System.Xml " \
            --replace-quiet "Facades/System.Runtime.Serialization.Xml_REFS := " "Facades/System.Runtime.Serialization.Xml_REFS := System.Xml " \
            --replace-quiet "Facades/System.Data.Common_REFS := " "Facades/System.Data.Common_REFS := System System.Xml "
        done
        if [ -f build/monodroid/Makefile ]; then
          substituteInPlace build/monodroid/Makefile \
            --replace-quiet "ECMA_KEY := ../../../../../mono/" "ECMA_KEY := ../../../../"
        fi
        make -j"$NIX_BUILD_CORES" V=1 SKIP_AOT=1 CSC=mcs
        unset makefile
        popd
      '';
      extraPostBuild = ''
        make -C mcs/tools/resx2sr SKIP_AOT=1 V=1
      '';
      extraPostInstall = ''
                gac="$out/lib/mono/gac"
                while IFS= read -r name; do
                  cat > "$name.config" <<EOF
        <configuration><dllmap dll="libodbc.so.2" target="${unixodbc}/lib/libodbc.so.2"/></configuration>
        EOF
                done < <(find "$gac" -name 'System.Data.dll' -type f)
                while IFS= read -r name; do
                  cat > "$name.config" <<EOF
        <configuration><dllmap dll="gdiplus" target="${libgdiplus}/lib/libgdiplus.so"/></configuration>
        EOF
                done < <(find "$gac" -name 'System.Drawing.dll' -type f)
                while IFS= read -r name; do
                  cat > "$name.config" <<EOF
        <configuration><dllmap dll="libX11" target="${libx11.out}/lib/libX11.so.6"/></configuration>
        EOF
                done < <(find "$gac" -name 'System.Windows.Forms.dll' -type f)
                if [ ! -x "$out/bin/resx2sr" ] && [ -f "$out/lib/mono/4.5/resx2sr.exe" ]; then
                  cat > "$out/bin/resx2sr" <<EOF
        #!${bash}/bin/sh
        exec "$out/bin/mono" "$out/lib/mono/4.5/resx2sr.exe" "\$@"
        EOF
                  chmod +x "$out/bin/resx2sr"
                fi
      '';
    };
  }
)
