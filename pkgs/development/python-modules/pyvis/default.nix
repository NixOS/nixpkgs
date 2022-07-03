{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, networkx
, jinja2
, ipython
, jsonpickle
, numpy
}:

buildPythonPackage rec {
  pname = "pyvis";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "WestHealth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cER5XYxnURzRLtrisWBu2kxtOiRqgaRTJYyaCMh2qqE=";
  };

  patches = [
    # Fix test: https://github.com/WestHealth/pyvis/issues/138
    (fetchpatch {
      url = "https://github.com/WestHealth/pyvis/commit/eaa24b882401e2e74353efa78bf4e71a880cfc47.patch";
      sha256 = "sha256-hyDypavoCM36SiuQda1U4FLUPdAjTIMtaeZ0KqfHKzI=";
    })
  ];

  propagatedBuildInputs = [ networkx jinja2 ipython jsonpickle ];

  checkInputs = [ numpy ];

  pythonImportsCheck = [ "pyvis" ];

  meta = with lib; {
    homepage = "https://github.com/WestHealth/pyvis";
    description = "Python package for creating and visualizing interactive network graphs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
