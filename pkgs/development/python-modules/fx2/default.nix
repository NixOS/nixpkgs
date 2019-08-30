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
  version = "unstable-2019-08-27";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "libfx2";
    rev = "dd1e42c7b46ff410dbb18beab46111bb5491400c";
    sha256 = "0xvlmx6ym0ylrvnlqzf18d475wa0mfci7wkdbv30gl3hgdhsppjz";
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
