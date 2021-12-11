{ lib
, buildPythonPackage
, fetchFromGitHub
, six
}:

buildPythonPackage rec {
  pname = "importmagic";
  version = "0.1.7";

  src = fetchFromGitHub {
     owner = "alecthomas";
     repo = "importmagic";
     rev = "0.1.7";
     sha256 = "1asijinpirq9ips9drsibyg2bj6qbpryz27n91akhvmzn78pbz7s";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false;  # missing json file from tarball

  meta = with lib; {
    description = "Python Import Magic - automagically add, remove and manage imports";
    homepage = "https://github.com/alecthomas/importmagic";
    license = licenses.bsd0;
  };

}
