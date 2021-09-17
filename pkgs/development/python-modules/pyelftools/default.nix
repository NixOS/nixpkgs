{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, stdenv
}:

buildPythonPackage rec {
  pname = "pyelftools";
  version = "0.27";

  src = fetchFromGitHub {
    owner = "eliben";
    repo = pname;
    rev = "v${version}";
    sha256 = "09igdym2qj2fvfcazbz25qybmgz7ccrn25xn3havfkdkka0z0i3p";
  };

  doCheck = stdenv.hostPlatform.system == "x86_64-linux";

  checkPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" test/external_tools/readelf
    ${python.interpreter} test/all_tests.py
  '';

  pythonImportsCheck = [ "elftools" ];

  meta = with lib; {
    description = "Python library for analyzing ELF files and DWARF debugging information";
    homepage = "https://github.com/eliben/pyelftools";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ igsha pamplemousse ];
  };
}
