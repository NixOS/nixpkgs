{ lib
, buildPythonPackage
, fetchPypi
, bleach
, bokeh
, param
, pyviz-comms
, markdown
, pyct
, testpath
, tqdm
, nodejs
}:

buildPythonPackage rec {
  pname = "panel";
  version = "0.13.1";

  format = "wheel";

  # We fetch a wheel because while we can fetch the node
  # artifacts using npm, the bundling invoked in setup.py
  # tries to fetch even more artifacts
  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-1GC119AUfmse3fhQQxSi9eDJJorYvt2NeE7UY1GrW3E=";
  };

  propagatedBuildInputs = [
    bleach
    bokeh
    param
    pyviz-comms
    markdown
    pyct
    testpath
    tqdm
  ];

  # infinite recursion in test dependencies (hvplot)
  doCheck = false;

  passthru = {
    inherit nodejs; # For convenience
  };

  meta = with lib; {
    description = "A high level dashboarding library for python visualization libraries";
    homepage = "https://pyviz.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
