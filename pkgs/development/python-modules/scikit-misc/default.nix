{ buildPythonPackage
, cython
, fetchFromGitHub
, gfortran
, lib
, numpy
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "scikit-misc";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h8lxyazvq3b2c8blj131zn8wkbzjb8ynpr2a7yaanblfsbzdv92";
  };

  patchPhase = ''
    substituteInPlace pytest.ini --replace "--cov --cov-report=xml" ""
  '';

  nativeBuildInputs = [ cython gfortran numpy ];

  # Testing packages that involve cython is a little tricky. We need to point
  # pytest to the output directory instead of the source directory. See
  #   * https://github.com/NixOS/nixpkgs/pull/137038
  #   * https://discourse.nixos.org/t/cant-import-cythonized-modules-at-checkphase/14207
  # for more information.
  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "${builtins.placeholder "out"}/${python.sitePackages}" ];

  meta = with lib; {
    description = "Miscellaneous tools for scientific computing.";
    homepage = "https://github.com/has2k1/scikit-misc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
