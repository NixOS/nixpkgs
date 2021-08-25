{ lib, buildPythonPackage, fetchFromGitHub
, arrow
, six
, hypothesis
, pytest
, pytest-runner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "inform";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "inform";
    rev = "v${version}";
    sha256 = "114cyff00j9r7qm2ld4w1a4kklr5gx570vk67p56gpr2553dkmly";
  };

  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ arrow six ];

  checkInputs = [ pytest hypothesis ];
  checkPhase = ''
    patchShebangs test.doctests.py test.inform.py
    ./test.doctests.py && ./test.inform.py && pytest
  '';

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
