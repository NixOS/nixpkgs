{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, llvmPackages
, zlib
, cython
, oldest-supported-numpy
, setuptools
, wheel
, astunparse
, numpy
, pyparsing
, scipy
, gsd
, networkx
, pandas
, pytest-xdist
, pytestCheckHook
, tables
}:

buildPythonPackage rec {
  pname = "mdtraj";
  version = "1.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdtraj";
    repo = "mdtraj";
    rev = "refs/tags/${version}";
    hash = "sha256-2Jg6DyVJlRBLD/6hMtcsrAdxKF5RkpUuhAQm/lqVGeE=";
  };

  patches = [
    (fetchpatch {
      name = "gsd_3-compatibility.patch";
      url = "https://github.com/mdtraj/mdtraj/commit/81209d00817ab07cfc4668bf5ec88088d16904c0.patch";
      hash = "sha256-ttNmij7csxF0Z5wPPwhGumRX055W2IgFjRAe6nI6GNY=";
    })
  ];

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    wheel
  ];

  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  propagatedBuildInputs = [
    astunparse
    numpy
    pyparsing
    scipy
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-incompatible-function-pointer-types";

  nativeCheckInputs = [
    gsd
    networkx
    pandas
    pytest-xdist
    pytestCheckHook
    tables
  ];

  preCheck = ''
    cd tests
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # require network access
    "test_pdb_from_url"
    "test_1vii_url_and_gz"

    # fail due to data race
    "test_read_atomindices_1"
    "test_read_atomindices_2"

    # flaky test
    "test_distances_t"
  ];

  pythonImportsCheck = [ "mdtraj" ];

  meta = with lib; {
    description = "An open library for the analysis of molecular dynamics trajectories";
    homepage = "https://github.com/mdtraj/mdtraj";
    changelog = "https://github.com/mdtraj/mdtraj/releases/tag/${src.rev}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ natsukium ];
  };
}
