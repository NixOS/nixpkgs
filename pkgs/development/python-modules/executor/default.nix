{ lib, buildPythonPackage, fetchFromGitHub, coloredlogs, property-manager, fasteners, pytest, mock, virtualenv }:

buildPythonPackage rec {
  pname = "executor";
  version = "21.3";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-executor";
    rev = version;
    sha256 = "0rc14vjx3d6irfaw0pczzw1pn0xjl7xikv32hc1fvxv2ibnldv5d";
  };

  propagatedBuildInputs = [ coloredlogs property-manager fasteners ];

  checkInputs = [ pytest mock virtualenv ];

  # ignore impure tests
  checkPhase = ''
    pytest . -k "not option and not retry \
                 and not remote and not ssh \
                 and not foreach and not local_context"
  '';

  meta = with lib; {
    description = "Programmer friendly subprocess wrapper";
    homepage = "https://github.com/xolox/python-executor";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
