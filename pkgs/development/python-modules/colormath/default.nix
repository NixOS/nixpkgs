{ buildPythonPackage
, fetchFromGitHub
, networkx
, nose
, numpy
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "colormath";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "gtaylor";
    rev = "3.0.0";
    repo = "python-colormath";
    sha256 = "1nqf5wy8ikx2g684khzvjc4iagkslmbsxxwilbv4jpaznr9lahdl";
  };

  propagatedBuildInputs = [ networkx numpy ];

  checkInputs = [ nose ];
  checkPhase = "nosetests";

  meta = with lib; {
    description = "Color math and conversion library";
    homepage = "https://github.com/gtaylor/python-colormath";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jonathanreeve ];
  };
}
