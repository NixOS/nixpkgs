{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pbr,
  requests,
  pytestCheckHook,
  waitress,
}:

buildPythonPackage rec {
  pname = "requests-unixsocket";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KDBCg+qTV9Rf/1itWxHkdwjPv1gGgXqlmyo2Mijulx4=";
  };

  patches = [
    # https://github.com/msabramo/requests-unixsocket/pull/69
    (fetchpatch {
      name = "urllib3-2-compatibility.patch";
      url = "https://github.com/msabramo/requests-unixsocket/commit/39b9c64847a52ddc8c6d14ff414a6a7a3f6358d9.patch";
      hash = "sha256-DFtjhk33JLCu7FW6XI7uf2klNmwzvh2QNwxUb4W223Q=";
    })
  ];

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    waitress
  ];

  pythonImportsCheck = [ "requests_unixsocket" ];

  meta = with lib; {
    description = "Use requests to talk HTTP via a UNIX domain socket";
    homepage = "https://github.com/msabramo/requests-unixsocket";
    license = licenses.asl20;
    maintainers = with maintainers; [ catern ];
  };
}
