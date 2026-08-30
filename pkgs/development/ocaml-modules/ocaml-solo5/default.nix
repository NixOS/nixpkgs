{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  findlib,
  fmt,
  opam,
  solo5,
  target ?
    if stdenv.targetPlatform.isx86_64 then
      "x86_64-solo5-none-static"
    else if stdenv.targetPlatform.isAarch64 then
      "aarch64-solo5-none-static"
    else
      throw "ocaml-solo5 does not support ${stdenv.targetPlatform.system}",
}:

assert lib.asserts.assertOneOf "ocaml-solo5's ocaml version" ocaml.version [
  "5.4.1"
  "5.5.0"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml-solo5";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-solo5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/xUF98MPhjv9yRWoRDx2uIkCr2Furz1qUJexIxnHhI4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    findlib
    ocaml
    opam
    solo5
  ];

  propagatedBuildInputs = [ solo5 ];

  setupHook = ./setup-hook.sh;

  # upstream uses `ocamlfind query ocaml-src` and patch with opatch
  # override with `ocaml.src` and apply patches
  postPatch = ''
    mkdir ocaml
    tar xf ${ocaml.src} -C ocaml --strip-components=1
    version=$(head -n1 ocaml/VERSION)
    if test -d "patches/$version"; then
      for p in "patches/$version"/*; do
        patch -d ocaml -p1 < "$p"
      done
    fi
  '';

  # stdenv exports these environment variables
  # ocaml configure script allow env vars to override target tool detection
  # which would produce incorrect cross compiler setup
  # see install check below
  preConfigure = ''
    unset CC CXX LD AR AS NM OBJCOPY OBJDUMP RANLIB READELF SIZE STRINGS STRIP
  '';

  configureScript = "./configure.sh";
  configureFlags = [ "--target=${target}" ];
  # only have --prefix, --sysroot, --target, --othertoolprefix, --ocaml-configure-option
  # don't allow stdenv configurePhase append autotools flags
  dontAddDisableDepTrack = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  dontStrip = true;

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/lib/ocaml-solo5/bin/ocamlopt.opt -config | grep "^c_compiler: .*-solo5-ocaml-"
    runHook postInstallCheck
  '';

  passthru = {
    inherit target;

    tests =
      let
        example =
          mode: attrs:
          buildDunePackage (
            {
              pname = "ocaml-solo5-example-${mode}";
              inherit (finalAttrs) version src;
              sourceRoot = "${finalAttrs.src.name}/example";

              __structuredAttrs = true;

              nativeBuildInputs = [ finalAttrs.finalPackage ];

              buildInputs = [ fmt ];

              env.MODE = mode;

              buildPhase = ''
                runHook preBuild
                dune build @default
                runHook postBuild
              '';

              doCheck = true;
              checkPhase = ''
                runHook preCheck
                dune build @runtest --display short
                runHook postCheck
              '';

              installPhase = ''
                runHook preInstall
                install -D _build/solo5/hello.exe $out/hello.${mode}
                runHook postInstall
              '';
            }
            // attrs
          );
      in
      {
        example-spt = example "spt" { };
        example-hvt = example "hvt" { requiredSystemFeatures = [ "kvm" ]; };
      };
  };

  meta = {
    description = "OCaml cross-compiler to the freestanding Solo5 backend";
    homepage = "https://github.com/mirage/ocaml-solo5";
    changelog = "https://raw.githubusercontent.com/mirage/ocaml-solo5/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stepbrobd ];
    teams = [ lib.teams.ngi ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
