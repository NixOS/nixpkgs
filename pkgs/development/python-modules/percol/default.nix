{ lib, buildPythonPackage, fetchFromGitHub, cmigemo }:

buildPythonPackage rec {
  pname = "percol";
  version = "unstable-2019-07-24";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mooz";
    repo = "percol";
    rev = "4b28037e328da3d0fe8165c11b800cbaddcb525e";
    sha256 = "07sq3517wzn04j2dzlmczmcvx3w6r7xnzz3634zgf1zi6dbr2a3g";
  };

  propagatedBuildInputs = [ cmigemo ];

  # package has no tests
  doCheck = false;
  pythonImportsCheck = [ "percol" ];

  meta = with lib; {
    homepage = "https://github.com/mooz/percol";
    description = "Adds flavor of interactive filtering to the traditional pipe concept of shell";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
