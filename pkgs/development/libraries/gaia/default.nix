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

  # This is not exactly specified in upstream's README but it's needed by the
  # resulting $out/bin/gaiafusion script
  pythonEnv = (if pythonSupport then
    pythonPackages.python.withPackages(ps: with ps; [
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
  postInstall = lib.optionalString (pythonSupport) ''
    # We can't use patchShebangs because it will use bare bones $python/bin/python
    # and we need a python environment with pyyaml
    wrapProgram $out/bin/gaiafusion --prefix PYTHONPATH : $out/${pythonPackages.python.sitePackages}:${pythonEnv}/${pythonPackages.python.sitePackages}
  '';

  meta = with lib; {
    homepage = "https://github.com/MTG/gaia";
    description = "General library to work with points in a semimetric space";
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
    license = licenses.agpl3;
  };
}
