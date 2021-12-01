{ buildPythonApplication, fetchFromGitHub, python-gnupg, lib}:

buildPythonApplication rec {
  pname = "pass2csv";
  version = "0.3.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "reinefjord";
    rev = "v${version}";
    sha256 = "sha256:1al2y2x4cwvaz9kcxfyqfvbnr99dykiycg2h6kgwqmh5hih0y221";
  };

  propagatedBuildInputs = [ python-gnupg ];

  meta = with lib; {
    description = "Export pass(1), 'the standard unix password manager', to CSV.";
    homepage = "https://github.com/reinefjord/pass2csv";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
