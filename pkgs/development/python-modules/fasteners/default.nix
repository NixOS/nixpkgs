{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, monotonic
, diskcache
, more-itertools
, testtools
, isPy3k
, nose
, futures ? null
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.16.3";

  src = fetchFromGitHub {
     owner = "harlowja";
     repo = "fasteners";
     rev = "0.16.3";
     sha256 = "1nsyy4b90gvcw1cma2mwwilcy8791z1hdf3a220nccxazndbay34";
  };

  propagatedBuildInputs = [
    six
    monotonic
  ];

  checkInputs = [
    diskcache
    more-itertools
    testtools
    nose
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "A python package that provides useful locks";
    homepage = "https://github.com/harlowja/fasteners";
    license = licenses.asl20;
  };

}
