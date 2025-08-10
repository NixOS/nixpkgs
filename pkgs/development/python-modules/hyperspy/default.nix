{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  setuptools,
  setuptools-scm,

  cloudpickle,
  dask,
  importlib-metadata,
  jinja2,
  matplotlib,
  natsort,
  numpy,
  packaging,
  pint,
  prettytable,
  pyyaml,
  rosettasciio,
  scikit-image,
  scipy,
  sympy,
  tqdm,
  traits,
}:

buildPythonPackage rec {
  pname = "hyperspy";
  version = "2.3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s2HJu+Wtfhj1rQX0FhfaH0yMqpIecjtNwAEVJETIzUQ=";
  };

  disabled = pythonOlder "3.9";

  buildInputs = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cloudpickle
    dask
    importlib-metadata
    jinja2
    matplotlib
    natsort
    numpy
    packaging
    pint
    prettytable
    pyyaml
    rosettasciio
    scikit-image
    scipy
    sympy
    tqdm
    traits
  ];

  pythonImportsCheck = [ "hyperspy" ];

  meta = with lib; {
    description = "Open source Python framework for exploring, visualizing and analyzing multi-dimensional data";
    homepage = "https://hyperspy.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
