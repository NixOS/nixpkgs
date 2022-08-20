{ lib, fetchFromGitHub, buildPythonPackage, six, pyudev, pygobject3 }:

buildPythonPackage rec {
  pname = "rtslib";
  version = "2.1.75";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-qBlr4K+LeJIC6Hwy6dN9n/VjHIUYCy8pLlRtPvooWyE=";
  };

  propagatedBuildInputs = [ six pyudev pygobject3 ];

  meta = with lib; {
    description = "A Python object API for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    license = licenses.asl20;
  };
}
