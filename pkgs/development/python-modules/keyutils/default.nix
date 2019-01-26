{ lib, buildPythonPackage, fetchFromGitHub, keyutils, pytestrunner, pytest }:

buildPythonPackage rec {
  pname = "keyutils";
  version = "0.5";

  # github version comes bundled with tests
  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = "python-keyutils";
    rev = "v${version}";
    sha256 = "1gga60w8sb3r5bxa0bfp7d7wzg6s3db5y7aizr14p2pvp92d8bdi";
  };

  buildInputs = [ keyutils ];
  checkInputs = [ pytest pytestrunner ];

  meta = {
    description = "A set of python bindings for keyutils";
    homepage = https://github.com/sassoftware/python-keyutils;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ primeos ];
  };
}
