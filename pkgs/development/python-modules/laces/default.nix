{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage rec {
  pname = "laces";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tbrlpld";
    repo = "laces";
    rev = "v${version}";
    hash = "sha256-N3UUJomlihdM+6w9jmn9t10Q2meIqEOjW/rf3ZLrD78=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [ "laces" ];

  meta = with lib; {
    description = "Django components that know how to render themselves";
    homepage = "https://github.com/tbrlpld/laces";
    changelog = "https://github.com/tbrlpld/laces/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
