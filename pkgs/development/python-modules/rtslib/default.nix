{ lib, fetchFromGitHub, buildPythonPackage, six, pyudev, pygobject3 }:

buildPythonPackage rec {
  pname = "rtslib";
  version = "2.1.74";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "1in10z6ckmkfhykar435k1fmswbfajysv4g9nsav893ij8g694fy";
  };

  propagatedBuildInputs = [ six pyudev pygobject3 ];

  meta = with lib; {
    description = "A Python object API for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    license = licenses.asl20;
  };
}
