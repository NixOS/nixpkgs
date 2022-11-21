{ buildPythonPackage
, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "plotext";
  version = "5.2.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "piccolomo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-V7N7p5RxLKYLmJeojikYJ/tT/IpVGzG3ZPVvUisDAVs=";
  };

  # Package does not have a conventional test suite that can be run with either
  # `pytestCheckHook` or the standard setuptools testing situation.
  doCheck = false;

  pythonImportsCheck = [ "plotext" ];

  meta = with lib; {
    description = "Plotting directly in the terminal";
    homepage = "https://github.com/piccolomo/plotext";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
