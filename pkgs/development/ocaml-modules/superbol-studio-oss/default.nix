{
  lib,
  stdenv,
  buildDunePackage,
  fetchFromGitHub,
  gnucobol,
  menhir,
  js_of_ocaml,
  gen_js_api,
  jsonoo,
  promise_jsoo,
  ppx_deriving,
  ppx_expect,
  ppx_import,
  ppx_deriving_encoding,
  menhirSdk,
  menhirLib,
  fmt,
  ocplib_stuff,
  ez_file,
  ez_api,
  ez_cmdliner,
  zarith,
  zarith_stubs_js,
  iso8601,
  lwt,
  ocamlgraph,
  jsonrpc,
  lsp,
  toml,
  camlp-streams,
  ansiterminal,
  alcotest,
  autofonce,
  goblint-cil,
  gcc,
  bison,
  buildPackages,
  versionCheckHook,
}:

buildDunePackage (finalAttrs: {
  pname = "superbol-studio-oss";
  version = "1.0.0";

  minimalOCamlVersion = "4.14";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "superbol-studio-oss";
    tag = finalAttrs.version;
    hash = "sha256-/MO229R61r+Wix0rmSw/VEWmTOeq48/RvqaS3Xa1kmI=";
    fetchSubmodules = true;
  };

  patches = [
    ./update-dependencies.patch
  ];

  nativeBuildInputs = [
    menhir
    gen_js_api
    gcc
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    finalAttrs.passthru.gnucobol.bin
  ];

  propagatedBuildInputs = [
    js_of_ocaml
    jsonoo
    promise_jsoo
    ppx_deriving
    ppx_expect
    ppx_import
    ppx_deriving_encoding
    menhirSdk
    menhirLib
    fmt
    ocplib_stuff
    ez_file
    ez_api
    ez_cmdliner
    zarith
    zarith_stubs_js
    iso8601
    lwt
    ocamlgraph
    jsonrpc
    lsp
    toml
    camlp-streams
    goblint-cil
  ];

  dunePackages = [
    "superbol-studio-oss"
    "superbol-vscode-lib"
    "superbol-free"
    "superbol_free_lib"
    "superbol_project"
    "node-js-stubs"
    "interop-js-stubs"
    "vscode-js-stubs"
    "vscode-json"
    "vscode-languageclient-js-stubs"
    "superbol_preprocs"
    "superbol_platform"
    "sql_preproc"
    "sql_ast"
    "sql_parser"
    "ez_toml"
    "ezr_toml"
    "cobol_typeck"
    "cobol_parser"
    "cobol_lsp"
    "cobol_indent"
    "cobol_common"
    "cobol_config"
    "cobol_cfg"
    "cobol_preproc"
    "cobol_data"
    "cobol_ptree"
    "cobol_unit"
    "pretty"
    "ppx_cobcflags"
    "ebcdic_lib"
    "h2mlstubs"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # Requires a pre-release version of gnucobol that macos cannot build
    "ezlibcob"
  ];

  preBuild = ''
    dune build src/lsp/cobol_parser
  '';

  # It's broken currently
  doCheck = false;
  checkInputs = [
    ansiterminal
    alcotest
    autofonce
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/superbol-free";

  passthru.gnucobol = gnucobol.overrideAttrs (old: {
    version = "3.2-unstable-2025-12-04";
    src = fetchFromGitHub {
      owner = "OCamlPro";
      repo = "gnucobol";
      rev = "4b8c07b3dfd125f4379599cf45756c076f7699c7";
      hash = "sha256-QNWiDHILDCGh+rFbacSXi8cwPAwaHoG8nNb3KBlvCPc=";
    };

    nativeBuildInputs = old.nativeBuildInputs ++ [
      bison
      buildPackages.flex
    ];

    postPatch = ''
      # upstream reports the following tests as known failures
      sed -i '/AT_SETUP(\[runtime check: write to internal storage (1)\])/a \
               AT_SKIP_IF(\[true\])' tests/testsuite.src/run_misc.at
      sed -i '/AT_SETUP(\[OPEN OUTPUT COMMIT \/ ROLLBACK\])/a \
               AT_SKIP_IF(\[true\])' tests/testsuite.src/run_file.at
    '';
    installFlags = [ "localedir=$out/share/locale" ];

    dontVersionCheck = true;

    # Requires a full autoreconf run, but this doesn't work on macos
    # Somehow causes segmentation faults when running the tests
    meta = old.meta // {
      broken = stdenv.hostPlatform.isDarwin;
    };
  });

  meta = {
    description = "Open-Source part of SuperBOL Studio, including the Visual Studio Code extension and its LSP server";
    homepage = "https://superbol.eu/";
    license =
      with lib.licenses;
      AND [
        agpl3Only # For the src/lsp directory, the actual lsp `superbol-free`
        mit # For vscode extension
        isc # Some content in src/vendor
        gpl3Only # for import/superbol-vscode-debug
      ];
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    teams = [ lib.teams.ngi ];
    mainProgram = "superbol-free";
  };
})
