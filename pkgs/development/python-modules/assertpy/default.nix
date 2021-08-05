{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "assertpy";
  version = "1.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0hnfh45cmqyp7zasrllwf8gbq3mazqlhhk0sq1iqlh6fig0yfq2f";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "assertpy" ];

  meta = with lib; {
    description = "Aassertion library for unit testing";
    homepage = "https://github.com/assertpy/assertpy";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
