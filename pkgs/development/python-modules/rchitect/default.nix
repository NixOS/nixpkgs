{ lib
, buildPythonPackage
, fetchFromGitHub
, cffi
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.3.39";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "v${version}";
    sha256 = "Hl2sYV8YVTzVHJr9LJDzuswoLgjVLT0kFIpIdt+uRzE=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  # Problems importing rchitect._cffi, which is a module built with
  # cffi
  doCheck = false;

  propagatedBuildInputs = [
    cffi
    six
  ];

  pythonImportsCheck = [ "rchitect" ];

  meta = with lib; {
    description = "Interoperate R with Python";
    homepage = "https://github.com/randy3k/rchitect";
    license = licenses.mit;
    maintainers = with maintainers; [ jdreaver ];
  };
}
