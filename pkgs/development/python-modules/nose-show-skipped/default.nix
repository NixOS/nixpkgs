{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "nose-show-skipped";
  version = "0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a202f9c4b35107e9e1d6d8438eff4a930cb31a7e17517a69b319448f136815ce";
  };

  propagatedBuildInputs = [ nose ];

  meta = with lib; {
    description = "A nose plugin to show skipped tests and their messages";
    homepage = "https://github.com/cpcloud/nose-show-skipped";
    maintainers = with maintainers; [ melsigl ];
    license = licenses.bsd3;
  };
}
