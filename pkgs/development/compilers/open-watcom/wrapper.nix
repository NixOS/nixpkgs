# Arguments that this derivation gets when it is created with `callPackage`
{ stdenv
, lib
, symlinkJoin
, makeWrapper
, runCommand
, file
}:

open-watcom:

let
  wrapper =
    {}:
    let
      binDirs = with stdenv.hostPlatform; if isWindows then [
        (lib.optionalString is64bit "binnt64")
        "binnt"
        (lib.optionalString is32bit "binw")
      ] else if (isDarwin && is64bit) then [
        "osx64"
      ] else [
        (lib.optionalString is64bit "binl64")
        "binl"
      ];
      includeDirs = with stdenv.hostPlatform; [
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
        tests = let
          wrapped = wrapper { };
        in {
          simple = runCommand "${name}-test-simple" { nativeBuildInputs = [ wrapped ]; } ''
            cat <<EOF >test.c
            #include <stdio.h>
            int main() {
              printf ("Testing OpenWatcom C89 compiler.\n");
              return 0;
            }
            EOF
            cat test.c
            # Darwin target not supported, only host
            wcl386 -fe=test_c test.c
            ${lib.optionalString (!stdenv.hostPlatform.isDarwin) "./test_c"}

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
            # Darwin target not supported, only host
            wcl386 -fe=test_cpp test.cpp
            ${lib.optionalString (!stdenv.hostPlatform.isDarwin) "./test_cpp"}
            touch $out
          '';
          cross = runCommand "${name}-test-cross" { nativeBuildInputs = [ wrapped file ]; } ''
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
            file ./linux | grep "32-bit" | grep "Linux"
            file ./nt.exe | grep "PE32" | grep "Windows"
            file ./dos4g.exe | grep "MS-DOS" | grep "LE executable"
            file ./windows.exe | grep "MS-DOS" | grep "Windows 3.x"
            file ./dos.exe | grep "MS-DOS" | grep -v "LE" | grep -v "Windows 3.x"
            touch $out
          '';
        };
      };

      inherit (open-watcom) meta;
    };
in
lib.makeOverridable wrapper
