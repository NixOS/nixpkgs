{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  texliveInfraOnly,

  # build-system
  poetry-core,
  setuptools,

  # buildInputs
  cairo,

  # dependencies
  av,
  beautifulsoup4,
  click,
  cloup,
  decorator,
  isosurfaces,
  manimpango,
  mapbox-earcut,
  moderngl,
  moderngl-window,
  networkx,
  numpy,
  pillow,
  pycairo,
  pydub,
  pygments,
  rich,
  scipy,
  screeninfo,
  skia-pathops,
  srt,
  svgelements,
  tqdm,
  typing-extensions,
  watchdog,

  # optional-dependencies
  jupyterlab,
  notebook,

  # tests
  ffmpeg,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
}:

let
  # According to ManimCommunity documentation manim uses tex-packages packaged
  # in a custom distribution called "manim-latex",
  #
  #   https://community.chocolatey.org/packages/manim-latex#files
  #
  # which includes another custom distribution called tinytex, for which the
  # package list can be found at
  #
  #   https://github.com/yihui/tinytex/blob/master/tools/pkgs-custom.txt
  #
  # these two combined add up to:
  manim-tinytex = texliveInfraOnly.withPackages (
    ps: with ps; [

      # tinytex
      amsfonts
      amsmath
      atbegshi
      atveryend
      auxhook
      babel
      bibtex
      bigintcalc
      bitset
      booktabs
      cm
      dehyph
      dvipdfmx
      dvips
      ec
      epstopdf-pkg
      etex
      etexcmds
      etoolbox
      euenc
      everyshi
      fancyvrb
      filehook
      firstaid
      float
      fontspec
      framed
      geometry
      gettitlestring
      glyphlist
      graphics
      graphics-cfg
      graphics-def
      grffile
      helvetic
      hycolor
      hyperref
      hyph-utf8
      iftex
      inconsolata
      infwarerr
      intcalc
      knuth-lib
      kvdefinekeys
      kvoptions
      kvsetkeys
      l3backend
      l3kernel
      l3packages
      latex
      latex-amsmath-dev
      latex-bin
      latex-fonts
      latex-tools-dev
      latexconfig
      latexmk
      letltxmacro
      lm
      lm-math
      ltxcmds
      lua-alt-getopt
      luahbtex
      lualatex-math
      lualibs
      luaotfload
      luatex
      mdwtools
      metafont
      mfware
      natbib
      pdfescape
      pdftex
      pdftexcmds
      plain
      psnfss
      refcount
      rerunfilecheck
      stringenc
      tex
      tex-ini-files
      times
      tipa
      tools
      unicode-data
      unicode-math
      uniquecounter
      url
      xcolor
      xetex
      xetexconfig
      xkeyval
      xunicode
      zapfding

      # manim-latex
      standalone
      everysel
      preview
      doublestroke
      setspace
      rsfs
      relsize
      ragged2e
      fundus-calligra
      microtype
      wasysym
      physics
      dvisvgm
      jknapltx
      wasy
      cm-super
      babel-english
      gnu-freefont
      mathastext
      cbfonts-fd
    ]
  );
  # https://github.com/ManimCommunity/manim/pull/4037
  av_13_1 = av.overridePythonAttrs (rec {
    version = "13.1.0";
    src = fetchFromGitHub {
      owner = "PyAV-Org";
      repo = "PyAV";
      tag = "v${version}";
      hash = "sha256-x2a9SC4uRplC6p0cD7fZcepFpRidbr6JJEEOaGSWl60=";
    };
  });
in
buildPythonPackage rec {
  pname = "manim";
  pyproject = true;
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = "manim";
    tag = "v${version}";
    hash = "sha256-eQgp/GwKsfQA1ZgqfB3HF2ThEgH3Fbn9uAtcko9pkjs=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  patches = [ ./pytest-report-header.patch ];

  buildInputs = [ cairo ];

  dependencies = [
    av_13_1
    beautifulsoup4
    click
    cloup
    decorator
    isosurfaces
    manimpango
    mapbox-earcut
    moderngl
    moderngl-window
    networkx
    numpy
    pillow
    pycairo
    pydub
    pygments
    rich
    scipy
    screeninfo
    skia-pathops
    srt
    svgelements
    tqdm
    typing-extensions
    watchdog
  ];

  optional-dependencies = {
    jupyterlab = [
      jupyterlab
      notebook
    ];
    # TODO package dearpygui
    # gui = [ dearpygui ];
  };

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ffmpeg
      manim-tinytex
    ])
  ];

  nativeCheckInputs = [
    ffmpeg
    manim-tinytex
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  # about 55 of ~600 tests failing mostly due to demand for display
  disabledTests = import ./failing_tests.nix;

  pythonImportsCheck = [ "manim" ];

  meta = {
    description = "Animation engine for explanatory math videos - Community version";
    longDescription = ''
      Manim is an animation engine for explanatory math videos. It's used to
      create precise animations programmatically, as seen in the videos of
      3Blue1Brown on YouTube. This is the community maintained version of
      manim.
    '';
    mainProgram = "manim";
    changelog = "https://docs.manim.community/en/latest/changelog/${version}-changelog.html";
    homepage = "https://github.com/ManimCommunity/manim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
