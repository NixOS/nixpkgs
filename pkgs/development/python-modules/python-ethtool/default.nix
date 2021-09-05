{ lib
, buildPythonPackage
, fetchFromGitHub
, pkg-config
, libnl
, nettools
}:

buildPythonPackage rec {
  pname = "python-ethtool";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "fedora-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Sp7ssfLZ/1FEKrvX257pKcaureZ5mdpJ7jCEh/ft1l0=";
  };

  postPatch = ''
    substituteInPlace tests/parse_ifconfig.py --replace "Popen('ifconfig'," "Popen('${nettools}/bin/ifconfig',"
  '';

  buildInputs = [ libnl ];
  nativeBuildInputs = [ pkg-config ];
  pythonImportsCheck = [ "ethtool" ];

  meta = with lib; {
    description = "Python bindings for the ethtool kernel interface";
    homepage = "https://github.com/fedora-python/python-ethtool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elohmeier ];
  };
}
