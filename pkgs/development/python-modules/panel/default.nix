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
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5eeec277524c3146b4f6fc5f0e9ba61755e9c088d50312ecf5e6058f9efb59e";
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
