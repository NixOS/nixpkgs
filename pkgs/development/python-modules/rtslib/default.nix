{ lib, fetchFromGitHub, fetchpatch, buildPythonPackage, six, pyudev, pygobject3 }:

buildPythonPackage rec {
  pname = "rtslib";
  version = "2.1.75";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "refs/tags/v${version}";
    hash = "sha256-qBlr4K+LeJIC6Hwy6dN9n/VjHIUYCy8pLlRtPvooWyE=";
  };

  patches = [
    # <https://github.com/open-iscsi/rtslib-fb/pull/187>
    (fetchpatch {
      url = "https://github.com/zhaofengli/rtslib-fb/commit/1c3c8257940a88e65676f4333363ddf259a06723.patch";
      hash = "sha256-nDzL8pUKwKIej+6rOg7Om5AkwkClKk6qKlImbpoufz4=";
    })
  ];

  propagatedBuildInputs = [ six pyudev pygobject3 ];

  meta = with lib; {
    description = "A Python object API for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    license = licenses.asl20;
  };
}
