{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, sdcc
, libusb1
, crcmod
}:

buildPythonPackage {
  pname = "fx2";
  version = "unstable-2019-09-23";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "libfx2";
    rev = "3adb4fc842f174b0686ed122c0309d68356edc11";
    sha256 = "0b3zp50mschsxi2v3192dmnpw32gwblyl8aswlz9a0vx1qg3ibzn";
  };

  nativeBuildInputs = [ sdcc ];

  propagatedBuildInputs = [ libusb1 crcmod ];

  preBuild = ''
    cd software
    ${python.pythonForBuild.interpreter} setup.py build_ext
  '';

  preInstall = ''
    mkdir -p $out/share/libfx2
    cp -R ../firmware/library/{.stamp,lib,include,fx2{rules,conf}.mk} \
      $out/share/libfx2
  '';

  # installCheckPhase tries to run build_ext again and there are no tests
  doCheck = false;

  meta = with lib; {
    description = "Chip support package for Cypress EZ-USB FX2 series microcontrollers";
    homepage = https://github.com/whitequark/libfx2;
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}
