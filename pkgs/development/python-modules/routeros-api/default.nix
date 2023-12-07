{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, mock
, tox
}:

buildPythonPackage rec {
  pname = "routeros-api";
  version = "0.17.0";
  format = "setuptools";

  # N.B. The version published on PyPI is missing tests.
  src = fetchFromGitHub {
    owner = "socialwifi";
    repo = pname;
    rev = version;
    sha256 = "wpIfeYZ1w/yoNCHLYFVjn0O4Rb+N5lfvYzhGuN+HDTA=";
  };

  nativeCheckInputs = [
    mock
    tox
  ];

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Python API to RouterBoard devices produced by MikroTik.";
    homepage = "https://github.com/socialwifi/RouterOS-api";
    license = licenses.mit;
    maintainers = with maintainers; [ quentin ];
    platforms = platforms.all;
  };
}
