{ lib
, buildPythonPackage
, fetchPypi
, bokeh
, param
, pyviz-comms
, markdown
, pyct
, testpath
, tqdm
}:

buildPythonPackage rec {
  pname = "panel";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iz20k7mqn0560r4358yrzvrrfn00h8s6dim7p7y4icpgjw2mjnb";
  };

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "A high level dashboarding library for python visualization libraries";
    homepage = "https://pyviz.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
