{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "bhopengraph";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "bhopengraph";
    tag = "v${version}";
    hash = "sha256-rpJZhABYsiv3uZdb6zLEYGYMOv8Gyd6kZ9k0d9Ob1FQ=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "bhopengraph" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Library to create BloodHound OpenGraphs";
    homepage = "https://github.com/p0dalirius/bhopengraph";
    changelog = "https://github.com/p0dalirius/bhopengraph/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
