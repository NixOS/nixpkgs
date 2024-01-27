{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, capstone
, cmsis-pack-manager
, colorama
, importlib-metadata
, importlib-resources
, intelhex
, intervaltree
, lark
, natsort
, prettytable
, pyelftools
, pylink-square
, pyusb
, pyyaml
, setuptools
, setuptools-scm
, typing-extensions
, stdenv
, hidapi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyocd";
  version = "0.36.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k3eCrMna/wVNUPt8b3iM2UqE+A8LhfJarKuZ3Jgihkg=";
  };

  patches = [
    # https://github.com/pyocd/pyOCD/pull/1332
    (fetchpatch {
      name = "libusb-package-optional.patch";
      url = "https://github.com/pyocd/pyOCD/commit/0b980cf253e3714dd2eaf0bddeb7172d14089649.patch";
      hash = "sha256-B2+50VntcQELeakJbCeJdgI1iBU+h2NkXqba+LRYa/0=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "libusb-package>=1.0,<2.0" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    capstone
    cmsis-pack-manager
    colorama
    importlib-metadata
    importlib-resources
    intelhex
    intervaltree
    lark
    natsort
    prettytable
    pyelftools
    pylink-square
    pyusb
    pyyaml
    typing-extensions
  ] ++ lib.optionals (!stdenv.isLinux) [
    hidapi
  ];

  pythonImportsCheck = [
    "pyocd"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/pyocd/pyOCD/releases/tag/v${version}";
    description = "Python library for programming and debugging Arm Cortex-M microcontrollers";
    downloadPage = "https://github.com/pyocd/pyOCD";
    homepage = "https://pyocd.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
