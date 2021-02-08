{ base58
, buildPythonPackage
, fetchFromGitHub
, isPy27
, lib
, morphys
, pytest
, pytestcov
, pytestrunner
, six
, variants
, varint
}:

buildPythonPackage rec {
  pname = "py-multihash";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = pname;
    rev = "v${version}";
    sha256 = "07qglrbgcb8sr9msqw2v7dqj9s4rs6nyvhdnx02i5w6xx5ibzi3z";
  };

  nativeBuildInputs = [
    pytestrunner
  ];

  propagatedBuildInputs = [
    base58
    morphys
    six
    variants
    varint
  ];

  checkInputs = [
    pytest
    pytestcov
  ];

  pythonImportsCheck = [ "multihash" ];

  disabled = isPy27;

  meta = with lib; {
    description = "Self describing hashes - for future proofing";
    homepage = "https://github.com/multiformats/py-multihash";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
