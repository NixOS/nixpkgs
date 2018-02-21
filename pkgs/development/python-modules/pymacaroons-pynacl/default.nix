{ lib, buildPythonPackage, fetchFromGitHub, pynacl, six }:

buildPythonPackage rec {
  pname = "pymacaroons-pynacl";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "pymacaroons";
    rev = "v${version}";
    sha256 = "0bykjk01zdndp6gjr30x46blsn0cvxa7j0zh5g8raxwaawchjhii";
  };

  propagatedBuildInputs = [ pynacl six ];

  # Tests require an old version of hypothesis
  doCheck = false;

  meta = with lib; {
    description = "Macaroon library for Python";
    homepage = https://github.com/matrix-org/pymacaroons;
    license = licenses.mit;
  };
}
