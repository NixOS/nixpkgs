{ callPackage, symlinkJoin, makeWrapper, stdenv, gcc, opencl-headers, opencl-icd }:

let
  unwrapped = callPackage ./unwrapped.nix {};

  path = stdenv.lib.makeBinPath [ gcc ];

  wrapped = symlinkJoin {
    name = "futhark-wrapped";
    buildInputs = [ makeWrapper ];
    paths = [ unwrapped ];
    postBuild = ''
      wrapProgram $out/bin/futhark-c \
        --prefix PATH : "${path}"

      wrapProgram $out/bin/futhark-opencl \
        --prefix PATH : "${path}" \
        --set NIX_CC_WRAPPER_x86_64_unknown_linux_gnu_TARGET_HOST 1 \
        --set NIX_CFLAGS_COMPILE "-I${opencl-headers}/include" \
        --set NIX_CFLAGS_LINK "-L${opencl-icd}/lib"
    '';
  };

in wrapped
