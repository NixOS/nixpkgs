{ lib
, buildPythonPackage
, fetchFromGitHub
, Babel
, humanize
, python-dateutil
, tzlocal
}:

buildPythonPackage rec {
  pname = "Delorean";
  version = "1.0.0";

  src = fetchFromGitHub {
     owner = "myusuf3";
     repo = "delorean";
     rev = "1.0.0";
     sha256 = "01ccr453z11cfgzijcj6xq9c2jr4wa4q2qhl15a2987mx0z379r2";
  };

  propagatedBuildInputs = [ Babel humanize python-dateutil tzlocal ];

  pythonImportsCheck = [ "delorean" ];

  # test data not included
  doCheck = false;

  meta = with lib; {
    description = "Delorean: Time Travel Made Easy";
    homepage = "https://github.com/myusuf3/delorean";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
