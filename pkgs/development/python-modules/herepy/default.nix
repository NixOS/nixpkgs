{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "herepy";
  version = "3.5.4";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "abdullahselek";
    repo = "HerePy";
    rev = version;
    sha256 = "0wnkyrzpahxg7yh2qf149fzgs4x2jx3lf458syzz3crm7qix2hsk";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "requests==2.25.1" "requests>=2.25.1"
  '';

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "herepy" ];

  meta = with lib; {
    description = "Library that provides a Python interface to the HERE APIs";
    homepage = "https://github.com/abdullahselek/HerePy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
