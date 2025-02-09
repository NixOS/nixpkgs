{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, pytestCheckHook
, pytest-click
}:

buildPythonPackage rec {
  pname = "click-shell";
  version = "2.1";
  format = "setuptools";

  # PyPi release is missing tests
  src = fetchFromGitHub {
    owner = "clarkperkins";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-4QpQzg0yFuOFymGiTI+A8o6LyX78iTJMqr0ernYbilI=";
  };

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytest-click
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "click_shell"
  ];

  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    description = "An extension to click that easily turns your click app into a shell utility";
    longDescription = ''
      This is an extension to click that easily turns your click app into a
      shell utility. It is built on top of the built in python cmd module,
      with modifications to make it work with click. It adds a 'shell' mode
      with command completion to any click app.
    '';
    homepage = "https://github.com/clarkperkins/click-shell";
    license = licenses.bsd3;
    maintainers = with maintainers; [ binsky ];
  };
}
