{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, capstone
, cmsis-pack-manager
, colorama
, intelhex
, intervaltree
, natsort
, prettytable
, pyelftools
, pylink-square
, pyusb
, pyyaml
, typing-extensions
, stdenv
, hidapi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyocd";
  version = "0.34.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Fpa2IEsLOQ8ylGI/5D6h+22j1pvrvE9IMIyhCtyM6qU=";
  };

  patches = [
    # https://github.com/pyocd/pyOCD/pull/1332
    (fetchpatch {
      name = "libusb-package-optional.patch";
      url = "https://github.com/pyocd/pyOCD/commit/0b980cf253e3714dd2eaf0bddeb7172d14089649.patch";
      sha256 = "sha256-B2+50VntcQELeakJbCeJdgI1iBU+h2NkXqba+LRYa/0=";
    })
  ];

  propagatedBuildInputs = [
    capstone
    cmsis-pack-manager
    colorama
    intelhex
    intervaltree
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

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyocd" ];

  postPatch = ''
    substituteInPlace setup.cfg \
        --replace "libusb-package>=1.0,<2.0" ""
  '';

  meta = with lib; {
    description = "Python library for programming and debugging Arm Cortex-M microcontrollers";
    homepage = "https://pyocd.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
