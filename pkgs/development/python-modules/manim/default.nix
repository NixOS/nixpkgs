{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,

  cairo,
  ffmpeg,
  texliveInfraOnly,

  click,
  click-default-group,
  cloup,
  colour,
  grpcio,
  grpcio-tools,
  importlib-metadata,
  isosurfaces,
  jupyterlab,
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
  watchdog,
}:

let
  # According to ManimCommunity documentation manim uses tex-packages packaged
  # in a custom distribution called "manim-latex",
  #
  #   https://community.chocolatey.org/packages/manim-latex#files
  #
  # which includes another cutom distribution called tinytex, for which the
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
      ms
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
in
buildPythonPackage rec {
  pname = "manim";
  pyproject = true;
  version = "0.18.1";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = "manim";
    rev = "refs/tags/v${version}";
    hash = "sha256-o+Wl3NMK6yopcsRVFtZuUE9c1GABa5d8rbQNHDJ4OiQ=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cloup"
    "isosurfaces"
    "pillow"
    "skia-pathops"
    "watchdog"
  ];

  patches = [ ./pytest-report-header.patch ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--no-cov-on-fail --cov=manim --cov-report xml --cov-report term" ""
  '';

  buildInputs = [ cairo ];

  propagatedBuildInputs = [
    click
    click-default-group
    cloup
    colour
    grpcio
    grpcio-tools
    importlib-metadata
    isosurfaces
    jupyterlab
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
    watchdog
  ];

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
    pytest-xdist
    pytestCheckHook
  ];

  # about 55 of ~600 tests failing mostly due to demand for display
  disabledTests = import ./failing_tests.nix;

  pythonImportsCheck = [ "manim" ];

  meta = with lib; {
    description = "Animation engine for explanatory math videos - Community version";
    longDescription = ''
      Manim is an animation engine for explanatory math videos. It's used to
      create precise animations programmatically, as seen in the videos of
      3Blue1Brown on YouTube. This is the community maintained version of
      manim.
    '';
    homepage = "https://github.com/ManimCommunity/manim";
    license = licenses.mit;
    maintainers = with maintainers; [ friedelino ];
  };
}
