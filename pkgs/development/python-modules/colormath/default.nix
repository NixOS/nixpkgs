{ buildPythonPackage
, fetchFromGitHub
, networkx
, nose
, numpy
, lib
}:

buildPythonPackage rec {
  pname = "colormath";
  # Switch to unstable which fixes an deprecation issue with newer numpy
  # versions, should be included in versions > 3.0
  # https://github.com/gtaylor/python-colormath/issues/104
  version = "unstable-2021-04-17";

  src = fetchFromGitHub {
    owner = "gtaylor";
    repo = "python-colormath";
    rev = "4a076831fd5136f685aa7143db81eba27b2cd19a";
    hash = "sha256-eACVPIQFgiGiVmQ/PjUxP/UH/hBOsCywz5PlgpA4dk4=";
  };

  propagatedBuildInputs = [ networkx numpy ];

  nativeCheckInputs = [ nose ];

  checkPhase = "nosetests";

  pythonImportsCheck = [ "colormath" ];

  meta = with lib; {
    description = "Color math and conversion library";
    homepage = "https://github.com/gtaylor/python-colormath";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jonathanreeve ];
  };
}
