{ stdenv, fetchFromGitHub, buildPythonPackage, six, pyudev, pygobject3 }:

buildPythonPackage rec {
  pname = "rtslib";
  version = "2.1.70";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo ="${pname}-fb";
    rev = "v${version}";
    sha256 = "14f527c28j43w5v1pasrk98jvrpqxa0gmqiafn1rim0x1yrwanjm";
  };

  propagatedBuildInputs = [ six pyudev pygobject3 ];

  meta = with stdenv.lib; {
    description = "A Python object API for managing the Linux LIO kernel target";
    homepage = https://github.com/open-iscsi/rtslib-fb;
    license = licenses.asl20;
  };
}
