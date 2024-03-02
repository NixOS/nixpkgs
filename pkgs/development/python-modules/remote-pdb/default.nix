{ buildPythonPackage, fetchFromGitHub, lib }:
buildPythonPackage rec {
  pname = "remote-pdb";
  version = "2.1.0";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = "python-remote-pdb";
    rev = "v${version}";
    hash = "sha256-/7RysJOJigU4coC6d/Ob2lrtw8u8nLZI8wBk4oEEY3g=";
  };
  meta = with lib; {
    description = "Remote vanilla PDB (over TCP sockets).";
    homepage = "https://github.com/ionelmc/python-remote-pdb";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}
