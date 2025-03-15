{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  texliveInfraOnly,

  # build-system
  setuptools,

  # dependencies
  addict,
  appdirs,
  colour,
  diskcache,
  fonttools,
  ipython,
  isosurfaces,
  manimpango,
  mapbox-earcut,
  matplotlib,
  moderngl,
  moderngl-window,
  numpy,
  pillow,
  pydub,
  pygments,
  pyopengl,
  pyperclip,
  pyyaml,
  rich,
  scipy,
  screeninfo,
  skia-pathops,
  svgelements,
  sympy,
  tqdm,
  typing-extensions,
  validators,

  # tests
  ffmpeg,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
}:

let
  # This is a list of all LaTeX packages used by manimgl according to manimlib/tex_templates.yml
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
in
buildPythonPackage {
  pname = "manimgl";
  pyproject = true;
  version = "1.7.2";

  # Using hash rev because the tarball for the tag v1.7.2 gives the source to 1.7.1
  src = fetchFromGitHub {
    owner = "3b1b";
    repo = "manim";
    rev = "0c69ab6a32d4193f03ba9a604278eb3ce9699518";
    hash = "sha256-NPfChSYXD25yd0lgBLOQSyy+ONuNSAVB+hPAdn8G7Ss=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    addict
    appdirs
    colour
    diskcache
    fonttools
    ipython
    isosurfaces
    manimpango
    mapbox-earcut
    matplotlib
    moderngl
    moderngl-window
    numpy
    pillow
    pydub
    pygments
    pyopengl
    pyperclip
    pyyaml
    rich
    scipy
    screeninfo
    skia-pathops
    svgelements
    sympy
    tqdm
    typing-extensions
    validators
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

  doCheck = false;

  nativeCheckInputs = [
    ffmpeg
    manim-tinytex
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = [ "-v" ];

  meta = {
    description = "Animation engine for explanatory math videos";
    longDescription = ''
      Manim is an engine for precise programmatic animations, designed for creating
      explanatory math videos, as seen in the videos of 3Blue1Brown on Youtube.
      This is the original version that is maintained by Grant Sanderson which is
      based on OpenGL.
    '';
    changelog = "https://3b1b.github.io/manim/development/changelog.html";
    homepage = "https://github.com/3b1b/manim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ L0L1P0P ];
    mainProgram = "manimgl";
  };
}
