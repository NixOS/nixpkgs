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
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53340615f30f67f3182793695ebe52bf25e7bbb0751aba6f29763244350d0f42";
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
