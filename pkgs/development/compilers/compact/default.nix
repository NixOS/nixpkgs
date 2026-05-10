{
  lib,
  stdenv,
  fetchFromGitHub,
  chez,
  nodejs,
  typescript,
}:
let
  nanopass = fetchFromGitHub {
    owner = "nanopass";
    repo = "nanopass-framework-scheme";
    rev = "f3100cedaf9ed7fb89647a770d855997b32cf17e";
    sha256 = "sha256-NsY+V0r/lgycSIVTeHcNjJ398YwEijLlaGySNdTopxw=";
  };
  rough-draft = fetchFromGitHub {
    owner = "akeep";
    repo = "rough-draft";
    rev = "6a5e64aa325d2fd7ab1e161cfcb45ba2f9a057de";
    sha256 = "sha256-/as+XqStSyHc/vLImmGgowxgVjqi/jITolH9D6AJfek=";
  };
in
stdenv.mkDerivation {
  pname = "compactc";
  version = "0.31.102";

  src = fetchFromGitHub {
    owner = "LFDT-Minokawa";
    repo = "compact";
    rev = "main";
    sha256 = "sha256-NEJNypYje+cgnZYGGgrlSclf54ap+SZzCBJDn4xEPsI=";
  };

  CHEZSCHEMELIBDIRS = "compiler::obj/compiler:third_party/compiler::obj/third_party/compiler:${nanopass}::obj/nanopass:${rough-draft}/src::obj/rough-draft:srcMaps::obj/srcMaps::obj/compiler";

  buildInputs = [
    nodejs
    typescript
    chez
  ];

  buildPhase = ''
    mkdir -p obj/compiler
    sed -e 's;#!/usr/bin/env .*;'`command -v scheme`' --program;' compiler/compactc.ss > obj/compiler/compactc.ss
    sed -e 's;#!/usr/bin/env .*;'`command -v scheme`' --program;' compiler/format-compact.ss > obj/compiler/format-compact.ss
    sed -e 's;#!/usr/bin/env .*;'`command -v scheme`' --program;' compiler/fixup-compact.ss > obj/compiler/fixup-compact.ss
    patchShebangs --host .

    scheme -q << END
      (reset-handler abort)
      (optimize-level 2)
      (compile-imported-libraries #t)
      (generate-wpo-files #t)
      (generate-inspector-information #f)
      (compile-profile #f)
      (compile-program "obj/compiler/compactc.ss" "obj/compiler/compactc.so")
      (compile-program "obj/compiler/format-compact.ss" "obj/compiler/format-compact.so")
      (compile-program "obj/compiler/fixup-compact.ss" "obj/compiler/fixup-compact.so")
      (compile-whole-program "obj/compiler/compactc.wpo" "obj/compactc")
      (compile-whole-program "obj/compiler/format-compact.wpo" "obj/format-compact")
      (compile-whole-program "obj/compiler/fixup-compact.wpo" "obj/fixup-compact")
    END
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp obj/compactc $out/bin
    cp obj/format-compact $out/bin
    cp obj/fixup-compact $out/bin
    chmod +x $out/bin/compactc
    chmod +x $out/bin/format-compact
    chmod +x $out/bin/fixup-compact
  '';

  meta = with lib; {
    description = "Compact compiler - Smart contract language for Midnight Network";
    homepage = "https://midnight.network";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ lib.maintainers.anshsonkusare ];
    mainProgram = "compactc";
  };
}