{ lib, fetchFromGitHub, buildPythonPackage, pytestCheckHook }:

buildPythonPackage rec {
  pname = "anybadge";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "jongracecox";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d02fnig04zlrhfqqcf4505vy4p51whl2ifilnx3mkhis9lcwrmr";
  };

  # setup.py reads its version from the TRAVIS_TAG environment variable
  TRAVIS_TAG = "v${version}";

  pythonImportsCheck = [ "anybadge" ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A Python project for generating badges for your projects, with a focus on simplicity and flexibility";
    license = licenses.mit;
    homepage = "https://github.com/jongracecox/anybadge";
    maintainers = [ maintainers.fabiangd ];
  };
}
