{ lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytest-runner,
  pytestCheckHook,
  python-dateutil,
  pymongo,
  mock,
  coverage
}:

buildPythonPackage rec {
  pname = "schematics";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jclKcX/4QbRCuWKdKq97Wo3q10Rbkt7/R8AJQTwnwVk=";
  };

  nativeBuildInputs = [
    pytest-runner
  ];

  checkInputs = [
    pytestCheckHook
    python-dateutil
    pymongo
    mock
    coverage
  ];

  # mo_installer is not maintained and not required for running this
  # package
  postPatch = ''
    substituteInPlace setup.py --replace "'mo_installer'," ""
  '';

  meta = with lib; {
    description = "Python Data Structures for Humans";
    homepage = "https://github.com/schematics/schematics";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
