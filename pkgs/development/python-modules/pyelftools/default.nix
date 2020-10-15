{ stdenv
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "pyelftools";
  version = "unstable-2020-09-23";

  src = fetchFromGitHub {
    owner = "eliben";
    repo = pname;
    rev = "ab84e68837113b2d700ad379d94c1dd4a73125ea";
    sha256 = "sha256-O7l1kj0k8bOSOtZJVzS674oVnM+X3oP00Ybs0qjb64Q=";
  };

  doCheck = stdenv.is64bit && !stdenv.isDarwin;

  checkPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" test/external_tools/readelf
    ${python.interpreter} test/all_tests.py
  '';

  pythonImportsCheck = [ "elftools" ];

  meta = with stdenv.lib; {
    description = "A library for analyzing ELF files and DWARF debugging information";
    homepage = "https://github.com/eliben/pyelftools";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ igsha pamplemousse ];
  };

}
