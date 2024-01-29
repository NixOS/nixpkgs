{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyelftools";
  version = "0.30";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eliben";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-A9etnN7G24/Gu8YlV/YDpxZV+TG2eVXGx2ZjVnA9ZD4=";
  };

  doCheck = stdenv.hostPlatform.system == "x86_64-linux" && stdenv.hostPlatform.isGnu;

  checkPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" test/external_tools/readelf
    ${python.interpreter} test/run_all_unittests.py
    ${python.interpreter} test/run_examples_test.py
    ${python.interpreter} test/run_readelf_tests.py --parallel
  '';

  pythonImportsCheck = [
    "elftools"
  ];

  meta = with lib; {
    description = "Python library for analyzing ELF files and DWARF debugging information";
    homepage = "https://github.com/eliben/pyelftools";
    changelog = "https://github.com/eliben/pyelftools/blob/v${version}/CHANGES";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ igsha pamplemousse ];
  };
}
