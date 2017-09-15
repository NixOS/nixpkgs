{ newScope, stdenv, wrapCC, wrapCCWith, symlinkJoin }:
let
  callPackage = newScope (self // {inherit stdenv;});

  self = {
    emscriptenfastcomp-unwrapped = callPackage ./emscripten-fastcomp.nix {};
    emscriptenfastcomp-wrapped = wrapCCWith stdenv.cc.libc ''
      # hardening flags break WASM support
      cat > $out/nix-support/add-hardening.sh
    '' self.emscriptenfastcomp-unwrapped;
    emscriptenfastcomp = symlinkJoin {
      name = "emscriptenfastcomp";
      paths = [ self.emscriptenfastcomp-wrapped self.emscriptenfastcomp-unwrapped ];
      preferLocalBuild = false;
      allowSubstitutes = true;
      postBuild = ''
        # replace unwrapped clang-3.9 binary by wrapper
        ln -sf $out/bin/clang $out/bin/clang-[0-9]*
      '';
    };
  };
in self
