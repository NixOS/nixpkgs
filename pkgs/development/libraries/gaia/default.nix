{ stdenv
, lib
, fetchFromGitHub
, libyaml
, swig
, pkgconfig
, wafHook
, makeWrapper
, qt4
, python
, pythonSupport ? true
# Default to false since it brakes the build
, stlfacadeSupport ? false
, assertsSupport ? true
, cyclopsSupport ? true
}:

assert pythonSupport -> python != null;

stdenv.mkDerivation rec {
  pname = "gaia";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "MTG";
    repo = "gaia";
    rev = "v${version}";
    sha256 = "12jxb354s2dblr2ghnl3w05m23jgzvrrgywfj8jaa32j3gw48fv2";
  };

  # Fix installation error when waf tries to put files in /etc/
  prePatch = ''
  '' + lib.optionalString cyclopsSupport ''
    substituteInPlace src/wscript \
      --replace "/etc/cyclops" "$out/etc/cyclops" \
      --replace "/etc/init.d" "$out/etc/init.d"
  '';

  # This is not exactly specified in upstream's README but it's needed by the
  # resultings $out/bin/gaiafusion script
  pythonEnv = (if pythonSupport then
    python.withPackages(ps: with ps; [
      pyyaml
    ])
  else null);

  nativeBuildInputs = [
    wafHook
    pkgconfig
    swig
    makeWrapper
  ];
  buildInputs = [
    libyaml
    qt4
  ]
    ++ lib.optionals (pythonSupport) [
      pythonEnv
    ]
  ;
  wafConfigureFlags = [
  ]
    ++ lib.optionals (pythonSupport) [ "--with-python-bindings" ]
    ++ lib.optionals (stlfacadeSupport) [ "--with-stlfacade" ]
    ++ lib.optionals (assertsSupport) [ "--with-asserts" ]
    ++ lib.optionals (cyclopsSupport) [ "--with-cyclops" ]
  ;
  # only gaiafusion is a python executable that needs patchShebangs
  postInstall = (if pythonSupport then ''
    # We can't use patchShebangs because it will use bare bones $python/bin/python
    # and we need a python environment with pyyaml
    wrapProgram $out/bin/gaiafusion --prefix PYTHONPATH : $out/${python.sitePackages}:${pythonEnv}/${python.sitePackages}
  '' else "");

  meta = with lib; {
    homepage = "https://github.com/MTG/gaia";
    description = "C++ library with python bindings which implements similarity measures and classiﬁcations on the results of audio analysis, and generates classiﬁcation models that Essentia can use to compute high-level description of music";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.agpl3;
  };
}
