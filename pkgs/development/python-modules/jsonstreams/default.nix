{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, six, }:

buildPythonPackage rec {
  pname = "jsonstreams";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dcbaker";
    repo = pname;
    rev = version;
    sha256 = "0c85fdqkj5k4b0v0ngx2d9qbmzdsvglh4j9k9h7508bvn7l8fa4b";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests --doctest-modules jsonstreams" ];

  meta = with lib; {
    description = "A JSON streaming writer";
    homepage = "https://github.com/dcbaker/jsonstreams";
    license = licenses.mit;
    maintainers = with maintainers; [ chkno ];
  };
}
