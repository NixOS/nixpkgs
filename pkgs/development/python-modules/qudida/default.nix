{ fetchPypi
, buildPythonPackage
, lib
, numpy
, scikit-learn
, typing-extensions
, opencv3
}:

buildPythonPackage rec {
  pname = "qudida";
  version = "0.0.4";
  src = fetchPypi {
    inherit pname version;
    sha256 = "2xmOKIerDJqgAj5WWvv/Qd+3azYfhf1eE/eA11uhjMg=";
  };
  propagatedBuildInputs = [
    numpy
    scikit-learn
    typing-extensions
    opencv3
  ];
  pythonImportsCheck = [ "qudida" ];

  ## This post patch creates a requirements.txt which is used by setup.py if it exists
  ## otherwise it gets the same dependencies plus opencv-python hardcoded
  ## the subsitute stops it from fishing for a source of opencv which we provide with opencv3
  postPatch = ''
    echo "numpy>=0.18.0" > requirements.txt
    echo "scikit-learn>=0.19.1" >> requirements.txt
    echo "typing-extensions" >> requirements.txt
    substituteInPlace setup.py --replace \
        "install_requires=get_install_requirements(INSTALL_REQUIRES, CHOOSE_INSTALL_REQUIRES)" \
        "install_requires=INSTALL_REQUIRES"
  '';

  meta = with lib; {
    description = "QuDiDA (QUick and DIrty Domain Adaptation)";
    homepage = "https://github.com/arsenyinfo/qudida";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cfhammill ];
  };
}
