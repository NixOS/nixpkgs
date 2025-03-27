{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pandas,
  requests,
  trio,
  asks,
}:

buildPythonPackage rec {
  pname = "netdata-pandas";
  version = "0.0.41";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata-pandas";
    rev = "v${version}";
    hash = "sha256-AXt8BKWyM3glm5hrRryb+vBzs3z2x61HhbR6DDZkh9o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pandas
    requests
    trio
    asks
  ];

  pythonImportsCheck = [ "netdata_pandas" ];

  meta = with lib; {
    description = "A helper library to pull data from the netdata REST API into a pandas dataframe.";
    homepage = "https://github.com/netdata/netdata-pandas";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
