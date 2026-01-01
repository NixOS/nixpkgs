{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "confight";
  version = "2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iodoexnh9tG4dgkjDXCUzWRFDhRlJ3HRgaNhxG2lwPY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ toml ];

  pythonImportsCheck = [ "confight" ];

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Python context manager for managing pid files";
    mainProgram = "confight";
    homepage = "https://github.com/avature/confight";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mkg20001 ];
=======
  meta = with lib; {
    description = "Python context manager for managing pid files";
    mainProgram = "confight";
    homepage = "https://github.com/avature/confight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mkg20001 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
