{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, numpy
, scipy
, scikit-learn
, tqdm
, attrdict
}:

buildPythonPackage rec {
  pname = "arm-mango";
  version = "1.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ARM-software";
    repo = "mango";
    rev = "v${version}";
    sha256 = "sha256-OUtbU7GqXYhxqiWYasvBw4f0eOkbZP5sAVMxa3HXi0s=";
  };

  buildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
    tqdm
    attrdict
  ];

  importCheck = [ "mango" ];

  meta = with lib; {
    description = "parallel bayesian optimization over complex search spaces";
    homepage = "https://github.com/ARM-software/mango";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nviets ];
  };
}
