{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-spinner";
  version = "0.1.10";

  src = fetchFromGitHub {
     owner = "click-contrib";
     repo = "click-spinner";
     rev = "v0.1.10";
     sha256 = "1b8fm9c0zldx0q0br8vqmrln3bk4by4q8lqjmvgih51x83lcd42y";
  };

  checkInputs = [
    click
    six
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Add support for showwing that command line app is active to Click";
    homepage = "https://github.com/click-contrib/click-spinner";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
