{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  libnl,
  nettools,
}:

buildPythonPackage rec {
  pname = "python-ethtool";
  version = "0.15";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fedora-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "0arkcfq64a4fl88vjjsx4gd3mhcpa7mpq6sblpkgs4k4m9mccz6i";
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
