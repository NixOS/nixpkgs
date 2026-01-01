{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  appdirs,
  jedi,
  prompt-toolkit,
  pygments,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ptpython";
<<<<<<< HEAD
  version = "3.0.32";
=======
  version = "3.0.30";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-EWUXeCNt6VxYK0JzcpTlCma6SiH6AcAJDqcIFa9Hj+A=";
=======
    hash = "sha256-UaB/m46/hDWlqusigxzKSlLocCl3GiY33ydjx509h3Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    jedi
    prompt-toolkit
    pygments
  ];

  # no tests to run
  doCheck = false;

  pythonImportsCheck = [ "ptpython" ];

<<<<<<< HEAD
  meta = {
    description = "Advanced Python REPL";
    homepage = "https://github.com/prompt-toolkit/ptpython";
    changelog = "https://github.com/prompt-toolkit/ptpython/blob/${version}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mlieberman85 ];
=======
  meta = with lib; {
    description = "Advanced Python REPL";
    homepage = "https://github.com/prompt-toolkit/ptpython";
    changelog = "https://github.com/prompt-toolkit/ptpython/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
