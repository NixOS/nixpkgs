{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, typing-extensions
, mypy
}:

buildPythonPackage rec {
  pname = "pandas-stubs";
  version = "1.2.0.39";

  disabled = isPy27;

  # Use GitHub source since PyPi source does not include tests
  src = fetchFromGitHub {
    owner = "VirtusLab";
    repo = pname;
    rev = "2bd932777d1050ea8f86c527266a4cd205aa15b1";
    sha256 = "m2McU53NNvRwnWKN9GL8dW1eCGKbTi0471szRQwZu1Q=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  pythonImportsCheck = [ "pandas" ];
  checkInputs = [ mypy ];
  checkPhase = ''
    mypy --config-file mypy.ini third_party/3/pandas tests/snippets
  '';

  meta = with lib; {
    description = "Type annotations for Pandas";
    homepage = "https://github.com/VirtusLab/pandas-stubs";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}
