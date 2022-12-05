{ stdenv
, lib
, buildPythonPackage
, chameleon
, fetchpatch
, fetchPypi
, pyramid
, pytestCheckHook
, setuptools
, zope_interface
}:

buildPythonPackage rec {
  pname = "pyramid-chameleon";
  version = "0.3";

  src = fetchPypi {
    pname = "pyramid_chameleon";
    inherit version;
    sha256 = "sha256-0XZ5KlDrAV14ZbRL2bJKe9BIn6mlzrvRe54FBIzvkBc=";
  };

  patches = [
    # https://github.com/Pylons/pyramid_chameleon/pull/25
    ./test-renderers-pyramid-import.patch
    # Compatibility with pyramid 2, https://github.com/Pylons/pyramid_chameleon/pull/34
    (fetchpatch {
      name = "support-later-limiter.patch";
      url = "https://github.com/Pylons/pyramid_chameleon/commit/36348bf4c01f52c3461e7ba4d20b1edfc54dba50.patch";
      sha256 = "sha256-cPS7JhcS8nkBS1T0OdZke25jvWHT0qkPFjyPUDKHBGU=";
    })
  ];

  propagatedBuildInputs = [
    chameleon
    pyramid
    setuptools
    zope_interface
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyramid_chameleon"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Chameleon template compiler for pyramid";
    homepage = "https://github.com/Pylons/pyramid_chameleon";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
