{ lib, buildPythonPackage, fetchFromGitHub
, arrow
, six
, hypothesis
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "inform";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "inform";
    rev = "v${version}";
    sha256 = "02zlprvidkz51aypss4knhv7dbr0sbpz3caqjzf9am2n1jx2viyy";
  };

  propagatedBuildInputs = [ arrow six ];

  checkInputs = [ pytest hypothesis ];
  checkPhase = "./test.doctests.py && ./test.inform.py && pytest";

  meta = with lib; {
    description = "Print and logging utilities";
    longDescription = ''
      Inform is designed to display messages from programs that are typically
      run from a console. It provides a collection of ‘print’ functions that
      allow you to simply and cleanly print different types of messages.
    '';
    homepage = "https://inform.readthedocs.io";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
