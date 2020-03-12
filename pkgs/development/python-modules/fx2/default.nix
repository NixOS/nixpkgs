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
  version = "unstable-2020-01-25";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "libfx2";
    rev = "d3e37f640d706aac5e69ae4476f6cd1bd0cd6a4e";
    sha256 = "1dsyknjpgf4wjkfr64lln1lcy7qpxdx5x3qglidrcswzv9b3i4fg";
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
