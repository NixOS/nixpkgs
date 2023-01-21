{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, setuptools-scm
, pint
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pint-pandas";
  version = "0.2";

  src = fetchPypi {
    pname = "Pint-Pandas";
    inherit version;
    sha256 = "sha256-b2DS6ArBAuD5St25IG4PbMpe5C8Lf4kw2MeYAC5B+oc=";
  };

  patches = [
    # Fixes a failing test, see: https://github.com/hgrecco/pint-pandas/issues/107
    (fetchpatch{
      url = "https://github.com/hgrecco/pint-pandas/commit/4c31e25609af968665ee60d019b9b5366f328680.patch";
      sha256 = "vIT0LI4S73D4MBfGI8vtCZAM+Zb4PZ4E3xfpGKNyA4I=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pint
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Pandas support for pint";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint-pandas";
    maintainers = with maintainers; [ doronbehar ];
  };
}
