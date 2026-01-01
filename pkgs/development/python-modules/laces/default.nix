{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage rec {
  pname = "laces";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tbrlpld";
    repo = "laces";
    tag = "v${version}";
    hash = "sha256-ELpPq7pqcLfAqUuHh8NOAOOiGPDImTFsA7WUHvVfMiI=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [ "laces" ];

<<<<<<< HEAD
  meta = {
    description = "Django components that know how to render themselves";
    homepage = "https://github.com/tbrlpld/laces";
    changelog = "https://github.com/tbrlpld/laces/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sephi ];
=======
  meta = with lib; {
    description = "Django components that know how to render themselves";
    homepage = "https://github.com/tbrlpld/laces";
    changelog = "https://github.com/tbrlpld/laces/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
