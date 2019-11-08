{ stdenv
, lib
, fetchFromGitHub
, libyaml
, swig
, pkgconfig
, wafHook
, makeWrapper
, qt4
, pythonPackages
, pythonSupport ? false
# Default to false since it breaks the build, see https://github.com/MTG/gaia/issues/11
, stlfacadeSupport ? false
, assertsSupport ? true
, cyclopsSupport ? true
}:

assert pythonSupport -> pythonPackages != null;

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

  nativeBuildInputs = [
    wafHook
    pkgconfig
    swig
  ]
    # The gaiafusion binary inside $out/bin needs a shebangs patch, and
    # wrapping with the appropriate $PYTHONPATH
    ++ lib.optionals (pythonSupport) [
      pythonPackages.wrapPython
    ]
  ;

  buildInputs = [
    libyaml
    qt4
  ];

  propagatedBuildInputs = []
    ++ lib.optionals (pythonSupport) [
      # This is not exactly specified in upstream's README but it's needed by the
      # resulting $out/bin/gaiafusion script
      pythonPackages.pyyaml
    ]
  ;

  wafConfigureFlags = []
    ++ lib.optionals (pythonSupport) [ "--with-python-bindings" ]
    ++ lib.optionals (stlfacadeSupport) [ "--with-stlfacade" ]
    ++ lib.optionals (assertsSupport) [ "--with-asserts" ]
    ++ lib.optionals (cyclopsSupport) [ "--with-cyclops" ]
  ;

  postFixup = ''
  ''
    + lib.optionalString pythonSupport ''
      wrapPythonPrograms
    ''
  ;

  meta = with lib; {
    homepage = "https://github.com/MTG/gaia";
    description = "General library to work with points in a semimetric space";
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
    license = licenses.agpl3;
  };
}
