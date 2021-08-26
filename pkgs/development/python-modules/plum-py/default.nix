{ lib, buildPythonPackage, fetchFromGitLab, isPy3k, pytest, baseline }:

buildPythonPackage rec {
  pname = "plum-py";
  version = "0.4.0";
  disabled = !isPy3k;

  src = fetchFromGitLab {
    owner = "dangass";
    repo = "plum";
    rev = "6a9ff863c0e9fa21f7b2230d25402155a5522e4b";
    sha256 = "1iv62yb704c61b0dvsmyp3j6xpbmay532g9ny4pw4zbg3l69vd5j";
  };

  postPatch = ''
    substituteInPlace src/plum/int/flag/_flag.py \
      --replace 'if sys.version_info < (3, 7):' 'if True:'
  '';

  checkInputs = [ pytest baseline ];
  checkPhase = "pytest tests";

  meta = with lib; {
    description = "Classes and utilities for packing/unpacking bytes";
    homepage = "https://plum-py.readthedocs.io/en/latest/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
