{ lib, buildPythonPackage, fetchFromGitHub, pytest, adb-shell, pure-python-adb }:

buildPythonPackage rec {
  pname = "androidtv";
  version = "0.0.37";

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0kxwn1p35wsqppc3lynd854nb31ffwb0khsc15c67jnk11l1fj0c";
  };

  propagatedBuildInputs = [ adb-shell pure-python-adb ];

  checkInputs = [
    pytest
  ] ++ lib.optionals isPy27 [ mock ];

  checkPhase = ''
    pytest tests/
    '';

  meta = with lib; {
    homepage = "https://github.com/JeffLIrion/androidtv";
    description = "androidtv is a Python 3 package that provides state information and control of Android TV and Fire TV devices via ADB";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
