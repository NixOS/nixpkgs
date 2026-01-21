# Arguments that this derivation gets when it is created with `callPackage`
{
  stdenv,
  lib,
  symlinkJoin,
  makeWrapper,
  runCommand,
  file,
}:

open-watcom:

let
  wrapper =
    { }:
    let
      archToBindir =
        with stdenv.hostPlatform;
        if isx86 then
          "bin"
        else if isAarch then
          "arm"
        # we don't support running on AXP
        # don't know what MIPS, PPC bindirs are called
        else
          throw "Don't know where ${system} binaries are located!";

      binDirs =
        with stdenv.hostPlatform;
        if isWindows then
          [
            (lib.optionalString is64bit "${archToBindir}nt64")
            "${archToBindir}nt"
            (lib.optionalString is32bit "${archToBindir}w")
          ]
        else if isDarwin then
          [
            (lib.optionalString is64bit "${archToBindir}o64")
            # modern Darwin cannot execute 32-bit code anymore
            (lib.optionalString is32bit "${archToBindir}o")
          ]
        else
          [
            (lib.optionalString is64bit "${archToBindir}l64")
            "${archToBindir}l"
          ];
      # TODO
      # This works good enough as-is, but should really only be targetPlatform-specific
      # but we don't support targeting DOS, OS/2, 16-bit Windows etc Nixpkgs-wide so this needs extra logic
      includeDirs =
        with stdenv.hostPlatform;
        [
          "h"
        ]
        ++ lib.optional isWindows "h/nt"
        ++ lib.optional isLinux "lh";
      listToDirs = list: lib.strings.concatMapStringsSep ":" (dir: "${placeholder "out"}/${dir}") list;
      name = "${open-watcom.passthru.prettyName}-${open-watcom.version}";
    in
    symlinkJoin {
      inherit name;

      paths = [ open-watcom ];

      nativeBuildInputs = [ makeWrapper ];

      postBuild = ''
        mkdir $out/bin

        for binDir in ${lib.strings.concatStringsSep " " binDirs}; do
          for exe in $(find ${open-watcom}/$binDir \
          -type f -executable \
          ${lib.optionalString stdenv.hostPlatform.isLinux "-not -iname '*.so' -not -iname '*.exe'"} \
          ); do
            if [ ! -f $out/bin/$(basename $exe) ]; then
              makeWrapper $exe $out/bin/$(basename $exe) \
                --set WATCOM ${open-watcom} \
                --prefix PATH : ${listToDirs binDirs} \
                --set EDPATH ${open-watcom}/eddat \
                --set INCLUDE ${listToDirs includeDirs}
            fi
          done
        done
      '';

      passthru = {
        unwrapped = open-watcom;
        tests =
          let
            wrapped = wrapper { };
          in
          {
            simple = runCommand "${name}-test-simple" { nativeBuildInputs = [ wrapped ]; } ''
              cat <<EOF >test.c
              #include <stdio.h>
              int main() {
                printf ("Testing OpenWatcom C89 compiler.\n");
                return 0;
              }
              EOF
              cat test.c
              wcl386 -fe=test_c test.c
              # Only test execution if hostPlatform is targetable
              ${lib.optionalString (!stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAarch) "./test_c"}

              cat <<EOF >test.cpp
              #include <string>
              #include <iostream>
              int main() {
                std::cout << "Testing OpenWatcom C++ library implementation." << std::endl;
                watcom::istring HELLO ("HELLO");
                if (HELLO != "hello") {
                  return 1;
                }
                if (HELLO.find ("ello") != 1) {
                  return 2;
                }
                return 0;
              }
              EOF
              cat test.cpp
              wcl386 -fe=test_cpp test.cpp
              # Only test execution if hostPlatform is targetable
              ${lib.optionalString (!stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAarch) "./test_cpp"}
              touch $out
            '';
            cross =
              runCommand "${name}-test-cross"
                {
                  nativeBuildInputs = [
                    wrapped
                    file
                  ];
                }
                ''
                  cat <<EOF >test.c
                  #include <stdio.h>
                  int main() {
                    printf ("Testing OpenWatcom cross-compilation.\n");
                    return 0;
                  }
                  EOF
                  cat test.c

                  echo "Test compiling"
                  wcl386 -bcl=linux -fe=linux test.c
                  wcl386 -bcl=nt -fe=nt test.c
                  wcl386 -bcl=dos4g -fe=dos4g test.c
                  wcl -bcl=windows -fe=windows test.c
                  wcl -bcl=dos -fe=dos test.c

                  echo "Test file format"
                  file ./linux
                  file ./linux | grep "ELF 32-bit" | grep -q "Linux"
                  file ./nt.exe
                  file ./nt.exe | grep "PE32 executable" | grep -q "Windows"
                  file ./dos4g.exe
                  file ./dos4g.exe | grep "MS-DOS executable" | grep -q "LE executable"
                  file ./windows.exe
                  file ./windows.exe | grep "MS-DOS executable" | grep -q "NE for MS Windows 3."
                  file ./dos.exe
                  file ./dos.exe | grep "MS-DOS executable" | grep -q "MZ for MS-DOS"
                  touch $out
                '';
          };
      };

      inherit (open-watcom) meta;
    };
in
lib.makeOverridable wrapper
