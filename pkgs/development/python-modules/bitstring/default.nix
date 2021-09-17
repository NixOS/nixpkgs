{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "bitstring";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = pname;
    rev = "bitstring-${version}";
    sha256 = "0y2kcq58psvl038r6dhahhlhp1wjgr5zsms45wyz1naq6ri8x9qa";
  };

  checkPhase = ''
    cd test
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [ "bitstring" ];

  meta = with lib; {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
