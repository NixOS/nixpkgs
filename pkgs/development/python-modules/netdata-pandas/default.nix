{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "from pkg_resources import parse_version" "from packaging.version import parse as parse_version"
  '';

  nativeBuildInputs = [
    packaging
    setuptools
  ];

  propagatedBuildInputs = [
    pandas
    requests
    trio
    asks
  ];

  pythonImportsCheck = [ "netdata_pandas" ];

  meta = {
    description = "Library to pull data from the netdata REST API into a pandas dataframe";
    homepage = "https://github.com/netdata/netdata-pandas";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
