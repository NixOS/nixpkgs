{ buildPythonPackage
, fetchFromGitHub
, lib
, numpy
, opencv4
, scikit-learn
, typing-extensions
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "qudida";
  version = "0.0.4";
  format = "setuptools";


  src = fetchFromGitHub {
    owner = "arsenyinfo";
    repo = "qudida";
    rev = version;
    sha256 = "sha256-4XQAdbqV6vRdwUDDdrilV9D8mGTUXUzPBWcX9LMwlvQ=";
  };

  disabled = pythonOlder "3.5.0";

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRemoveDeps = [ "opencv-python-headless" ];

  propagatedBuildInputs =
    [ numpy scikit-learn typing-extensions opencv4 ];

  doCheck = false; #tests seem to burn cpu endlessly without progress

  pythonImportsCheck = [
    "qudida"
  ];

  meta = with lib; {
    description = "QUick and DIrty Domain Adaptation";
    homepage = "https://github.com/arsenyinfo/qudida";
    maintainers = with maintainers; [ gbtb ];
    licence = licenses.mit;
    platforms = opencv4.meta.platforms;
  };
}

