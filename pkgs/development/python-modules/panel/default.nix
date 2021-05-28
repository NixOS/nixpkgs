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
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e86d82bdd5e7664bf49558eedad62b664d5403ec9e422e5ddfcf69e3bd77318";
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
