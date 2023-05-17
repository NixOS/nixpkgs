{ lib, buildPythonPackage, fetchFromGitHub, cython, jq, pytestCheckHook }:

buildPythonPackage rec {
  pname = "jq";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "jq.py";
    rev = version;
    hash = "sha256-1EQm5ShjFHbO1IO5QD42fsGHFGDBrJulLrcl+WeU7wo=";
  };

  patches = [
    # Removes vendoring
    ./jq-py-setup.patch
  ];

  nativeBuildInputs = [ cython ];

  buildInputs = [ jq ];

  preBuild = ''
    cython jq.pyx
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jq" ];

  meta = {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ benley ];
  };
}
