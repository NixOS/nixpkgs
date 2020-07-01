{ stdenv, fetchFromGitHub, buildPythonPackage, six, pyudev, pygobject3 }:

buildPythonPackage rec {
  pname = "rtslib";
  version = "2.1.72";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "13kycf9xkyxm1ik8yh3qpd96vird8y65daigyiyb4jvx0lmrd0kv";
  };

  propagatedBuildInputs = [ six pyudev pygobject3 ];

  meta = with stdenv.lib; {
    description = "A Python object API for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    license = licenses.asl20;
  };
}
