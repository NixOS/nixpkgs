{
  stdenv,
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchgit,
  setuptools-scm,
  pdfium-binaries,
  numpy,
  pillow,
  pytestCheckHook,
  removeReferencesTo,
  python,
  replaceVars,
}:

let
  pdfiumVersion = "${pdfium-binaries.version}";

  headers = fetchgit {
    url = "https://pdfium.googlesource.com/pdfium";
    # The latest revision on the chromium/${pdfiumVersion} branch
    rev = "9232d7c94a0007377a8034222f47683fe391d474";
    hash = "sha256-dI3jTyVYc0EmMLHTiVjGSf3C2noS9Ru5WijEJFtiSFk=";
    sparseCheckout = [
      "public"
    ];
  };

  # They demand their own fork of ctypesgen
  ctypesgen = buildPythonPackage rec {
    pname = "ctypesgen";
    version = "1.1.1+g${src.rev}"; # the most recent tag + git version
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pypdfium2-team";
      repo = "ctypesgen";
      rev = "848e9fbb1374f7f58a7ebf5e5da5c33292480b30";
      hash = "sha256-3JA7cW/xaEj/DxMHEypROwrKGo7EwUEcipRqALTvydw=";
    };

    patches = [
      (replaceVars ./fix-cc-detection.patch {
        cc = "${stdenv.cc.targetPrefix}cc";
      })
    ];

    build-system = [
      setuptools-scm
    ];

    env.SETUPTOOLS_SCM_PRETEND_VERSION = "${version}";
  };

in
buildPythonPackage rec {
  pname = "pypdfium2";
  version = "4.30.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypdfium2-team";
    repo = "pypdfium2";
    tag = version;
    hash = "sha256-v8f/XruGJYK3H9z4Q1rLg4fEnPHa8tTOlNTBMVxPEgA=";
  };

  build-system = [
    ctypesgen
    setuptools-scm
  ];

  nativeBuildInputs = [
    removeReferencesTo
  ];

  propagatedBuildInputs = [
    pdfium-binaries
  ];

  # Build system insists on fetching from the internet unless "cached" files
  # are prepared. Even then, some code patching needs to happen to make it not
  # talk to the internet.

  # The project doesn't seem very open to allow for offline building either,
  # see: https://github.com/pypdfium2-team/pypdfium2/discussions/274
  preBuild =
    let
      pdfiumLib = lib.makeLibraryPath [ pdfium-binaries ];
      inputVersionFile = (pkgs.formats.json { }).generate "version.json" {
        version = lib.strings.toInt pdfiumVersion;
        source = "generated";
        flags = [ ];
        run_lds = [ pdfiumLib ];
        guard_symbols = false;
      };
      bindingsDir = "data/bindings";
      headersDir = "${bindingsDir}/headers";
      versionFile = "${bindingsDir}/version.json";
    in
    ''
      # Preseed the headers and version file
      mkdir -p ${bindingsDir}
      cp -r ${headers}/public ${headersDir}
      install -m 644 ${inputVersionFile} ${versionFile}

      # Make generated bindings consider pdfium derivation path when loading dynamic libraries
      substituteInPlace setupsrc/pypdfium2_setup/emplace.py \
        --replace-fail 'build_pdfium_bindings(pdfium_ver, flags=flags, guard_symbols=True, run_lds=[])' \
                       'build_pdfium_bindings(pdfium_ver, flags=flags, guard_symbols=True, run_lds=["${pdfiumLib}"])'

      # Short circuit the version pull from the internet
      substituteInPlace setupsrc/pypdfium2_setup/packaging_base.py \
        --replace-fail 'PdfiumVer.to_full(build)._asdict()' \
                       '{"major": 133, "minor": 0, "build": ${pdfiumVersion}, "patch": 1}'
    '';
  env.PDFIUM_PLATFORM = "system:${pdfiumVersion}";

  # Remove references to stdenv in comments.
  postInstall = ''
    remove-references-to -t ${stdenv.cc.cc} $out/${python.sitePackages}/pypdfium2_raw/bindings.py
  '';

  nativeCheckInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pypdfium2"
  ];

  meta = {
    changelog = "https://github.com/pypdfium2-team/pypdfium2/releases/tag/${version}";
    description = "Python bindings to PDFium";
    homepage = "https://pypdfium2.readthedocs.io/";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ booxter ];
  };
}
