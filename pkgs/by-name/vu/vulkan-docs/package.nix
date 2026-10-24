{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  asciidoctor-with-extensions,
  hexapdf,
  nodejs_24,
  python3,
  python3Packages,
  nodePackages,
  katex ? nodePackages.katex,
  he ? nodePackages.he,
  allExtensions ? true,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vulkan-docs";
  version = "1.4.319";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-euJSkdJtith+eeiYM3zYEmJx/4yaVqcBLU0NKjj83l0=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    asciidoctor-with-extensions
    nodejs_24
    python3
    python3Packages.pyparsing
    he
    hexapdf
  ];

  patches = [
    ./add-man3-target.patch
    ./no-internal-katex.patch
    ./remove-escape-string-regexp.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-quiet "KATEXDIR =" "KATEXDIR = ${katex}/lib/node_modules/katex/dist #"

    substituteInPlace config/katex_replace/extension.rb \
      --replace-warn "../katex/" "${katex}/lib/node_modules/katex/dist/"
  '';

  preBuild = toString (
    lib.optional allExtensions ''
      makeFlagsArray+=(EXTENSIONS="$(python3 ${./all-extensions.py})")
    ''
  );

  makeFlags = [ "alldocs" ];

  postBuild = ''
    # replace html-style formatting and use known sections
    substituteInPlace gen/out/man/man3/* \
      --replace-quiet "<code>" "\fB" \
      --replace-quiet "</code>" "\fP" \
      --replace-quiet "<strong>" "\fI" \
      --replace-quiet "<strong class=\"purple\">" "\fI" \
      --replace-quiet "</strong>" "\fP" \
      --replace-quiet "C SPECIFICATION" "SYNOPSIS"

    # replace .URL with bold typesetting
    find gen/out/man/man3 -type f -exec \
      sed -i 's/\.URL "\(.*\)\.html" ".*" ".*"/\\fB\1\\fP/g' '{}' \;
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/man
    mv gen/out/man/man3 $out/share/man/man3
    mv gen/out $out/share/doc
    runHook postInstall
  '';

  meta = {
    description = "Vulkan API Specification and related tools";
    homepage = "https://github.com/KhronosGroup/Vulkan-Docs";
    license = with lib.licenses; [
      # taken from https://github.com/KhronosGroup/Vulkan-Docs/blob/v1.4.318/LICENSE.adoc
      asl20
      cc-by-40
      mit
      mplus
    ];
    maintainers = [ lib.maintainers.evythedemon ];
    platforms = lib.platforms.all;
  };
})
