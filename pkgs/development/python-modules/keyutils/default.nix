{ lib, buildPythonPackage, fetchFromGitHub, keyutils, pytest-runner, pytest }:

buildPythonPackage rec {
  pname = "keyutils";
  version = "0.6";

  # github version comes bundled with tests
  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = "python-keyutils";
    rev = version;
    sha256 = "0pfqfr5xqgsqkxzrmj8xl2glyl4nbq0irs0k6ik7iy3gd3mxf5g1";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
  '';

  buildInputs = [ keyutils ];
  checkInputs = [ pytest pytest-runner ];

  meta = {
    description = "A set of python bindings for keyutils";
    homepage = "https://github.com/sassoftware/python-keyutils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ primeos ];
  };
}
