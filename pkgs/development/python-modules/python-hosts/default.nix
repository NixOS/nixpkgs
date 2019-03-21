{ stdenv, buildPythonPackage, fetchPypi, pyyaml, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "python-hosts";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e5f04430fdaf09d6a7d9e82aa989669bc70fbba3e3e263f112a3e85193259b6";
  };

  # win_inet_pton is required for windows support
  prePatch = ''
    substituteInPlace setup.py --replace "install_requires=['win_inet_pton']," ""
    substituteInPlace python_hosts/utils.py --replace "import win_inet_pton" ""
  '';

  checkInputs = [ pyyaml pytest pytestcov ];

  # Removing 1 test file (it requires internet connection) and keeping the other two
  checkPhase = ''
    pytest tests/test_hosts_entry.py
    pytest tests/test_utils.py
  '';

  meta = with stdenv.lib; {
    description = "A library for managing a hosts file. It enables adding and removing entries, or importing them from a file or URL";
    homepage = https://github.com/jonhadfield/python-hosts;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

