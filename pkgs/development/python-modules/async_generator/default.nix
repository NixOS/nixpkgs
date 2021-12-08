{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, isPy35, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "async_generator";
  version = "1.10";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
     owner = "python-trio";
     repo = "async_generator";
     rev = "v1.10";
     sha256 = "1qa5082j4jf66z14hi8ihbzk5hbdfw9aj4qvsqbaicmn0bi8sws3";
  };

  checkInputs = [ pytest pytest-asyncio ];

  checkPhase = ''
    pytest -W error -ra -v --pyargs async_generator
  '';

  # disable tests on python3.5 to avoid circular dependency with pytest-asyncio
  doCheck = !isPy35;

  meta = with lib; {
    description = "Async generators and context managers for Python 3.5+";
    homepage = "https://github.com/python-trio/async_generator";
    license = with licenses; [ mit asl20 ];
  };
}
