{ lib
, buildPythonPackage
, fetchFromGitHub
, cffi
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.3.32";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "0f3d5a191cca895a1cb9c41f8391520a08e8b9fc";
    sha256 = "B+laYoW1XEq+XOoD/gjDngy8o9OSFJPpqdXVpvDIjLA=";
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
