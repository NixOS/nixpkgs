{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyelftools";
  version = "0.28";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eliben";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+T5C0ah2oj5E8fWaQbuzYRVgD5bSiUbaArrlxNLojvw=";
  };

  doCheck = stdenv.hostPlatform.system == "x86_64-linux" && stdenv.hostPlatform.isGnu;

  checkPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" test/external_tools/readelf
    ${python.interpreter} test/all_tests.py
  '';

  pythonImportsCheck = [
    "elftools"
  ];

  meta = with lib; {
    description = "Python library for analyzing ELF files and DWARF debugging information";
    homepage = "https://github.com/eliben/pyelftools";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ igsha pamplemousse ];
  };
}
