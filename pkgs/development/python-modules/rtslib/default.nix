{ stdenv, fetchFromGitHub, buildPythonPackage, six, pyudev, pygobject3 }:

buildPythonPackage rec {
  pname = "rtslib";
  version = "2.1.fb69";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo ="${pname}-fb";
    rev = "v${version}";
    sha256 = "17rlcrd9757nq91pa8xjr7147k7mxxp8zdka7arhlgsp3kcnbsfd";
  };

  propagatedBuildInputs = [ six pyudev pygobject3 ];

  meta = with stdenv.lib; {
    description = "A Python object API for managing the Linux LIO kernel target";
    homepage = https://github.com/open-iscsi/rtslib-fb;
    license = licenses.asl20;
  };
}
