{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, click
, isPy3k
, futures ? null
}:

buildPythonPackage rec {
  pname = "click-threading";
  version = "0.5.0";

  src = fetchFromGitHub {
     owner = "click-contrib";
     repo = "click-threading";
     rev = "0.5.0";
     sha256 = "185pzw12ap7wrjpyxhsyrkhh7i1l5qclaa3zlpn8qvm39fz0kjni";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ click ] ++ lib.optional (!isPy3k) futures;

  checkPhase = ''
    py.test
  '';

  # Tests are broken on 3.x
  doCheck = !isPy3k;

  meta = {
    homepage = "https://github.com/click-contrib/click-threading/";
    description = "Multithreaded Click apps made easy";
    license = lib.licenses.mit;
  };
}
