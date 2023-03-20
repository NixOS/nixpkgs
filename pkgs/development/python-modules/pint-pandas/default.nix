{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, setuptools
, pint
, pandas
, pytestCheckHook
}:

buildPythonPackage {
  pname = "pint-pandas";
  # Latest release contains bugs and failing tests.
  version = "unstable-2022-11-24";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "pint-pandas";
    rev = "c58a7fcf9123eb65f5e78845077b205e20279b9d";
    hash = "sha256-gMZNJSJxtSZvgU4o71ws5ZA6tgD2M5c5oOrn62DRyMI=";
  };

  nativeBuildInputs = [
    setuptools
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
