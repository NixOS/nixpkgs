{ lib, buildPythonPackage, fetchPypi, pyyaml, pytest, pytest-cov }:

buildPythonPackage rec {
  pname = "python-hosts";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4SAXjx5pRDhv4YVUgrUttyUa5izpYqpDKiiGJc2y8V0=";
  };

  # win_inet_pton is required for windows support
  prePatch = ''
    substituteInPlace setup.py --replace "install_requires=['win_inet_pton']," ""
    substituteInPlace python_hosts/utils.py --replace "import win_inet_pton" ""
  '';

  nativeCheckInputs = [ pyyaml pytest pytest-cov ];

  # Removing 1 test file (it requires internet connection) and keeping the other two
  checkPhase = ''
    pytest tests/test_hosts_entry.py
    pytest tests/test_utils.py
  '';

  meta = with lib; {
    description = "A library for managing a hosts file. It enables adding and removing entries, or importing them from a file or URL";
    homepage = "https://github.com/jonhadfield/python-hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

