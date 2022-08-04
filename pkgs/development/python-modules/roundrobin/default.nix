{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "roundrobin";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "linnik";
    repo = pname;
    rev = version;
    sha256 = "sha256-eedE4PE43sbJE/Ktrc31KjVdfqe2ChKCYUNIl7fir0E=";
  };

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    homepage = "https://github.com/linnik/roundrobin";
    description = "Collection of roundrobin utilities";
    license = licenses.mit;
    maintainers = with maintainers; [ wesnel ];
  };
}
