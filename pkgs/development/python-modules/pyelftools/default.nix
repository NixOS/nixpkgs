{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyelftools";
  version = "0.32";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eliben";
    repo = "pyelftools";
    tag = "v${version}";
    hash = "sha256-58Twjf7ECOPynQ5KPCTDQWdD3nb7ADJZISozWGRGoXM=";
  };

  build-system = [ setuptools ];

  doCheck = stdenv.hostPlatform.system == "x86_64-linux" && stdenv.hostPlatform.isGnu;

  checkPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" test/external_tools/readelf
    ${python.interpreter} test/run_all_unittests.py
    ${python.interpreter} test/run_examples_test.py
    ${python.interpreter} test/run_readelf_tests.py --parallel
  '';

  pythonImportsCheck = [ "elftools" ];

  meta = {
    description = "Python library for analyzing ELF files and DWARF debugging information";
    homepage = "https://github.com/eliben/pyelftools";
    changelog = "https://github.com/eliben/pyelftools/blob/v${version}/CHANGES";
    license = with lib.licenses; [
      # Public domain with Unlicense waiver.
      unlicense
      # pyelftools bundles construct library that is licensed under MIT license.
      # See elftools/construct/{LICENSE,README} in the source code.
      mit
    ];
    maintainers = with lib.maintainers; [
      igsha
      pamplemousse
    ];
    mainProgram = "readelf.py";
  };
}
