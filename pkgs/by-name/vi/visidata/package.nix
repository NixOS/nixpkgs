{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  # dependencies
  xclip,

  # tests
  versionCheckHook,

  withPcap ? true,
  withXclip ? stdenv.hostPlatform.isLinux,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "visidata";
  version = "3.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5utXfafQP6uZ7vXQAYXfV26y0qHbk6vulPl6DXbVX4=";
  };

  build-system = with python3Packages; [
    setuptools
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
      #tabula
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

      #requests_cache
      beautifulsoup4

      faker
      praw
      zulip
      #pyairtable

      setuptools
      importlib-metadata
    ]
    ++ lib.optionals withPcap (
      with python3Packages;
      [
        dpkt
        dnslib
      ]
    )
    ++ lib.optionals withXclip [
      xclip
    ];

  nativeCheckInputs = [
    versionCheckHook
  ];

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
    bash dev/test.sh
  '';

  postInstall = ''
    python dev/zsh-completion.py
    install -Dm644 _visidata -t $out/share/zsh/site-functions
  '';

  pythonImportsCheck = [ "visidata" ];

  meta = {
    description = "Interactive terminal multitool for tabular data";
    mainProgram = "visidata";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      raskin
      markus1189
    ];
    homepage = "https://visidata.org/";
    changelog = "https://github.com/saulpw/visidata/blob/${finalAttrs.src.rev}/CHANGELOG.md";
  };
})
