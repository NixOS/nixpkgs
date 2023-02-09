{ stdenv, lib, autoPatchelfHook, fetchzip, xz, ncurses5, readline, gmp, mpfr
, expat, libipt, zlib, dejagnu, sourceHighlight, python3, elfutils, guile, glibc
, majorVersion
}:

let
  throwUnsupportedSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  versionMap = rec {
    "11" = {
      gccVersion = "11.2.0";
      alireRevision = "4";
    } // {
      x86_64-darwin = {
        hash = "sha256-FmBgD20PPQlX/ddhJliCTb/PRmKxe9z7TFPa2/SK4GY=";
        upstreamTriplet = "x86_64-apple-darwin19.6.0";
      };
      x86_64-linux = {
        hash = "sha256-8fMBJp6igH+Md5jE4LMubDmC4GLt4A+bZG/Xcz2LAJQ=";
        upstreamTriplet = "x86_64-pc-linux-gnu";
      };
    }.${stdenv.hostPlatform.system} or throwUnsupportedSystem;
    "12" = {
      gccVersion = "12.1.0";
      alireRevision = "2";
    } // {
      x86_64-darwin = {
        hash = "sha256-zrcVFvFZMlGUtkG0p1wST6kGInRI64Icdsvkcf25yVs=";
        upstreamTriplet = "x86_64-apple-darwin19.6.0";
      };
      x86_64-linux = {
        hash = "sha256-EPDPOOjWJnJsUM7GGxj20/PXumjfLoMIEFX1EDtvWVY=";
        upstreamTriplet = "x86_64-pc-linux-gnu";
      };
    }.${stdenv.hostPlatform.system} or throwUnsupportedSystem;
  };

in with versionMap.${majorVersion};

stdenv.mkDerivation rec {
  pname = "gnatboot";
  inherit gccVersion alireRevision;

  version = "${gccVersion}-${alireRevision}";

  src = fetchzip {
    url = "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-${version}/gnat-${stdenv.hostPlatform.system}-${version}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [
    dejagnu
    expat
    gmp
    guile
    libipt
    mpfr
    ncurses5
    python3
    readline
    sourceHighlight
    xz
    zlib
  ] ++ lib.optional stdenv.buildPlatform.isLinux [
    autoPatchelfHook
    elfutils
    glibc
  ];

  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    substituteInPlace lib/gcc/${upstreamTriplet}/${gccVersion}/install-tools/mkheaders.conf \
      --replace "SYSTEM_HEADER_DIR=\"/usr/include\"" "SYSTEM_HEADER_DIR=\"/include\""
  ''
  # The included fixincl binary that is called during header fixup has a
  # hardcoded execvp("/usr/bin/sed", ...) call, but /usr/bin/sed isn't
  # available in the Nix Darwin stdenv.  Fortunately, execvp() will search the
  # PATH environment variable for the executable if its first argument does not
  # contain a slash, so we can just change the string to "sed" and zero the
  # other bytes.
  + ''
     sed -i "s,/usr/bin/sed,sed\x00\x00\x00\x00\x00\x00\x00\x00\x00," libexec/gcc/${upstreamTriplet}/${gccVersion}/install-tools/fixincl
  '';

  installPhase = ''
    mkdir -p $out
    cp -ar * $out/
  ''

  # So far with the Darwin gnatboot binary packages, there have been two
  # types of dylib path references to other dylibs that need fixups:
  #
  # 1.  Dylibs in $out/lib with paths starting with
  #     /Users/runner/.../gcc/install that refer to other dylibs in $out/lib
  # 2.  Dylibs in $out/lib/gcc/*/*/adalib with paths starting with
  #     @rpath that refer to other dylibs in $out/lib/gcc/*/*/adalib
  #
  # Additionally, per Section 14.4 Fixed Headers in the GCC 12.2.0 manual [2],
  # we have to update the fixed header files in current Alire GCC package, since it
  # was built against macOS 10.15 (Darwin 19.6.0), but Nix currently
  # builds against macOS 10.12, and the two header file structures differ.
  # For example, the current Alire GCC package has a fixed <stdio.h>
  # from macOS 10.15 that contains a #include <_stdio.h>, but neither the Alire
  # GCC package nor macOS 10.12 have such a header (<xlocale/_stdio.h> and
  # <secure/_stdio.h> in 10.12 are not equivalent; indeed, 10.15 <_stdio.h>
  # says it contains code shared by <stdio.h> and <xlocale/_stdio.h>).
  #
  # [2]: https://gcc.gnu.org/onlinedocs/gcc-12.2.0/gcc/Fixed-Headers.html

  + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    upstreamBuildPrefix="/Users/runner/work/GNAT-FSF-builds/GNAT-FSF-builds/sbx/x86_64-darwin/gcc/install"
    for i in "$out"/lib/*.dylib "$out"/lib/gcc/*/*/adalib/*.dylib; do
      if [[ -f "$i" && ! -h "$i" ]]; then
        install_name_tool -id "$i" "$i" || true
        for old_path in $(otool -L "$i" | grep "$upstreamBuildPrefix" | awk '{print $1}'); do
          new_path=`echo "$old_path" | sed "s,$upstreamBuildPrefix,$out,"`
          install_name_tool -change "$old_path" "$new_path" "$i" || true
        done
        for old_path in $(otool -L "$i" | grep "@rpath" | awk '{print $1}'); do
          new_path=$(echo "$old_path" | sed "s,@rpath,$(dirname "$i"),")
          install_name_tool -change "$old_path" "$new_path" "$i" || true
        done
      fi
    done

    "$out"/libexec/gcc/${upstreamTriplet}/${gccVersion}/install-tools/mkheaders -v -v \
      "$out" "${stdenv.cc.libc}"
  '';

  passthru = {
    langC = true; # TRICK for gcc-wrapper to wrap it
    langCC = false;
    langFortran = false;
    langAda = true;
    isGNU = true;
  };

  meta = with lib; {
    description = "GNAT, the GNU Ada Translator";
    homepage = "https://www.gnu.org/software/gnat";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ethindp ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
