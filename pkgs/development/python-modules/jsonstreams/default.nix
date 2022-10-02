{ stdenv, lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, six, }:

buildPythonPackage rec {
  pname = "jsonstreams";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dcbaker";
    repo = pname;
    rev = version;
    sha256 = "0qw74wz9ngz9wiv89vmilbifsbvgs457yn1bxnzhrh7g4vs2wcav";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests --doctest-modules jsonstreams" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A JSON streaming writer";
    homepage = "https://github.com/dcbaker/jsonstreams";
    license = licenses.mit;
    maintainers = with maintainers; [ chkno ];
  };
}
