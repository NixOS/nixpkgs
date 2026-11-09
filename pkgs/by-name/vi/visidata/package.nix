{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  groff,
  man-db,

  # dependencies
  xclip,
  glibcLocales,

  # tests
  versionCheckHook,

  withPcap ? true,
  # tabula-py pulls in openjdk
  withTabula ? false,
  withXclip ? stdenv.hostPlatform.isLinux,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "visidata";
  version = "3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lvs8BFgHdr51MCFtTbQVK4iFUwn5b5o/L6rmMGwA5To=";
  };

  postPatch = ''
    patchShebangs dev/mkman.sh visidata/man/parse_options.py
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    groff
    man-db
  ];

  dependencies =
    with python3Packages;
    [
      # from visidata/requirements.txt
      # packages not (yet) present in nixpkgs are commented
      python-dateutil
      pandas
      requests
      lxml
      openpyxl
      xlrd
      standard-mailcap
      xlwt
      h5py
      psycopg2
      boto3
      pyshp
      #mapbox-vector-tile
      pypng
      #pyconll
      msgpack
      brotli
      #fecfile
      fonttools
      #sas7bdat
      #xport
      #savReaderWriter
      pyyaml
      #namestand
      #datapackage
      pdfminer-six
      vobject
      tabulate
      wcwidth
      zstandard
      odfpy
      urllib3
      pyarrow
      seaborn
      matplotlib
      sh
      psutil
      numpy
      shapely
      duckdb

      requests-cache
      beautifulsoup4

      faker
      praw
      zulip
      pyairtable
      matrix-client
      pyxlsb
    ]
    ++ lib.optionals withPcap (
      with python3Packages;
      [
        dpkt
        dnslib
      ]
    )
    ++ lib.optionals withTabula [ python3Packages.tabula-py ]
    ++ lib.optionals withXclip [
      xclip
    ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  # tests/issue3195.vdx sets LC_NUMERIC=en_US.UTF-8
  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  # check phase uses the output bin, which is not possible when cross-compiling
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    # disable some tests which require access to the network
    rm tests/load-http-flaky.vd       # http
    rm tests/messenger-nosave.vd      # dns

    # tests to disable because we don't have a package to load such files
    rm tests/load-conllu.vdj          # no 'pyconll'
    rm tests/load-fec.vdj             # no 'fecfile'

    patchShebangs tests/
    substituteInPlace tests/test-vdx.sh --replace-fail "bin/vd" "$out/bin/vd"
  '';

  checkPhase = ''
    runHook preCheck
    bash dev/test.sh
    runHook postCheck
  '';

  postInstall = ''
    python dev/zsh-completion.py
    install -Dm644 _visidata -t $out/share/zsh/site-functions
  '';

  pythonImportsCheck = [ "visidata" ];

  meta = {
    description = "Interactive terminal multitool for tabular data";
    mainProgram = "visidata";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      raskin
      markus1189
    ];
    homepage = "https://visidata.org/";
    changelog = "https://github.com/saulpw/visidata/blob/${finalAttrs.src.tag}/CHANGELOG.md";
  };
})
