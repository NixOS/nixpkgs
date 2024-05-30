{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  crossandra,
  dahlia,
  pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "samarium";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samarium-lang";
    repo = "samarium";
    rev = "refs/tags/${version}";
    hash = "sha256-4WVkTLE6OboNJE/f+6zS3xT1jEHUwV4HSLjl/PBP0FU=";
  };

  build-system = [ poetry-core pythonRelaxDepsHook ];
  dependencies = [ crossandra dahlia ];

  patches = [ ./crossandra-2-fix.patch ];
  pythonRelaxDeps = [ "crossandra" ];

  meta = with lib; {
    changelog = "https://github.com/samarium-lang/samarium/blob/${src.rev}/CHANGELOG.md";
    description = "The Samarium Programming Language";
    license = licenses.mit;
    homepage = "https://samarium-lang.github.io/Samarium";
    maintainers = with maintainers; [ sigmanificient ];
  };
}
