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
  version = "0.34.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2zDr6fnA2MCTT/hNVvk7u3gugMo+nUF2E2VsOPhJXH4=";
  };

  patches = [
    # https://github.com/pyocd/pyOCD/pull/1332
    (fetchpatch {
      name = "libusb-package-optional.patch";
      url = "https://github.com/pyocd/pyOCD/commit/0b980cf253e3714dd2eaf0bddeb7172d14089649.patch";
      hash = "sha256-B2+50VntcQELeakJbCeJdgI1iBU+h2NkXqba+LRYa/0=";
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

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyocd" ];

  postPatch = ''
    substituteInPlace setup.cfg \
        --replace "libusb-package>=1.0,<2.0" "" \
        --replace "pylink-square>=0.11.1,<1.0" "pylink-square>=0.11.1,<2.0"
  '';

  meta = with lib; {
    description = "Python library for programming and debugging Arm Cortex-M microcontrollers";
    homepage = "https://pyocd.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
