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
  version = "0.11.1";
  # Version 10 attempts to download models from the web during build-time
  # https://github.com/holoviz/panel/issues/1819

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce531e5c0c8a8ae74d523762aeb1666650caebbe1867aba16129d29791e921f9";
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
