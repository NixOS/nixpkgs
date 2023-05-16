{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, pkgconfig
, setuptools
, wheel
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "faust-cchardet";
<<<<<<< HEAD
  version = "2.1.19";
=======
  version = "2.1.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "faust-streaming";
    repo = "cChardet";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-yY6YEhXC4S47rxnkKAta4m16IVGn7gkHSt056bYOYJ4=";
=======
    hash = "sha256-jTOqxBss/FAb8nMkU62H6O4ysmirD2FTA9mtvxXh43k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
    pkgconfig
    setuptools
    wheel
  ];

  postFixup = ''
    # fake cchardet distinfo, so packages that depend on cchardet
    # accept it as a drop-in replacement
    ln -s $out/${python.sitePackages}/{faust_,}cchardet-${version}.dist-info
  '';

  pythonImportsCheck = [
    "cchardet"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/faust-streaming/cChardet/blob/${src.rev}/CHANGES.rst";
    description = "High-speed universal character encoding detector";
    homepage = "https://github.com/faust-streaming/cChardet";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [ dotlambda ivan ];
  };
}
