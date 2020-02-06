{ stdenv, fetchFromGitHub, buildPythonPackage, six, pyudev, pygobject3 }:

buildPythonPackage rec {
  pname = "rtslib";
  version = "2.1.71";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo ="${pname}-fb";
    rev = "v${version}";
    sha256 = "0cn9azi44hf59mp47207igv72kjbkyz4rsvgzmwbpz0s57b0hnab";
  };

  propagatedBuildInputs = [ six pyudev pygobject3 ];

  meta = with stdenv.lib; {
    description = "A Python object API for managing the Linux LIO kernel target";
    homepage = https://github.com/open-iscsi/rtslib-fb;
    license = licenses.asl20;
  };
}
