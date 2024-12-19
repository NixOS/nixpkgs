{
  lib,
  fetchPypi,
  buildPythonPackage,
  requests,
  hidapi,
}:

buildPythonPackage rec {
  pname = "python-u2flib-host";
  version = "3.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02pwafd5kyjpc310ys0pgnd0adff1laz18naxxwsfrllqafqnrxb";
  };

  propagatedBuildInputs = [
    requests
    hidapi
  ];

  # Tests fail: "ValueError: underlying buffer has been detached"
  doCheck = false;

  meta = with lib; {
    description = "Python based U2F host library";
    homepage = "https://github.com/Yubico/python-u2flib-host";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jluttine ];
  };
}
