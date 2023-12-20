{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, sdcc
, libusb1
, crcmod
}:

buildPythonPackage rec {
  pname = "fx2";
  version = "unstable-2023-09-20";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "libfx2";
    rev = "73fa811818d56a86b82c12e07327946aeddd2b3e";
    hash = "sha256-AGQPOVTdaUCUeVVNQTBmoNvz5CGxcBOK7+oL+X8AcIw=";
  };

  nativeBuildInputs = [ sdcc ];

  propagatedBuildInputs = [ libusb1 crcmod ];

  preBuild = ''
    make -C firmware
    cd software
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
    homepage = "https://github.com/whitequark/libfx2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}
