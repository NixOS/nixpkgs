{ lib
, buildPythonPackage
, fetchPypi
, graphviz
, jupyter
, matplotlib
, networkx
, opt-einsum
, pandas
, pillow
, pyro-api
, pythonOlder
, torch
, scikit-learn
, seaborn
, torchvision
, tqdm
, wget
}:

buildPythonPackage rec {
  pname = "pyro-ppl";
<<<<<<< HEAD
  version = "1.8.6";
=======
  version = "1.8.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
<<<<<<< HEAD
    hash = "sha256-ANL03ailPmbZVRJNxuSektz1cM071waCUJHbdk2TzQc=";
=======
    hash = "sha256-dm+tYeUt9IiF3pbUEhPaH46MG3ns8witUxifzRXBy0E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyro-api
    torch
    networkx
    opt-einsum
    tqdm
  ];

  passthru.optional-dependencies = {
    extras = [
      graphviz
      jupyter
      # lap
      matplotlib
      pandas
      pillow
      scikit-learn
      seaborn
      torchvision
      # visdom
      wget
    ];
  };

  # pyro not shipping tests do simple smoke test instead
  doCheck = false;

  pythonImportsCheck = [
    "pyro"
    "pyro.distributions"
    "pyro.infer"
    "pyro.optim"
  ];

  meta = with lib; {
    description = "Library for probabilistic modeling and inference";
    homepage = "http://pyro.ai";
<<<<<<< HEAD
    changelog = "https://github.com/pyro-ppl/pyro/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ teh georgewhewell ];
  };
}
