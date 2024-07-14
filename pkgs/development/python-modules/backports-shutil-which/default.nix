{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytest,
}:

buildPythonPackage rec {
  pname = "backports-shutil-which";
  version = "3.5.2";

  src = fetchPypi {
    pname = "backports.shutil_which";
    inherit version;
    hash = "sha256-/jn1Z8vk+tieisTb6yP4fvgPf+joKWadAiHs2wQ3wTM=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test test
  '';

  meta = with lib; {
    description = "Backport of shutil.which from Python 3.3";
    homepage = "https://github.com/minrk/backports.shutil_which";
    license = licenses.psfl;
    maintainers = with maintainers; [ jluttine ];
  };
}
