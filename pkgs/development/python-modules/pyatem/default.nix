{ lib
, stdenv
, buildPythonPackage
, fetchFromSourcehut

# build-system
, setuptools

# dependencies
, pyusb
, tqdm
, zeroconf

# tests
, pillow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyatem";
  version = "0.9.0"; # check latest version in setup.py
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "pyatem";
    rev = version;
    hash = "sha256-ntwUhgC8Cgrim+kU3B3ckgPDmPe+aEHDP4wsB45KbJg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyusb
    tqdm
    zeroconf
  ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  preCheck = ''
    TESTDIR=$(mktemp -d)
    cp -r pyatem/{test_*.py,fixtures} $TESTDIR/
    pushd $TESTDIR
  '';

  disabledTests = lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # colorspace mapping has weird, but constant offsets on aarch64-linux
    "test_blueramp"
    "test_greenramp"
    "test_hues"
    "test_primaries"
    "test_redramp"
  ];

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "pyatem"
  ];

  meta = with lib; {
    description = "Library for controlling Blackmagic Design ATEM video mixers";
    homepage = "https://git.sr.ht/~martijnbraam/pyatem";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
