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
  version = "0.9";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "libfx2";
    rev = "v${version}";
    hash = "sha256-Uk+K7ym92JX4fC3PyTNxd0UvBzoNZmtbscBYjSWChuk=";
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
    homepage = "https://github.com/whitequark/libfx2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}
