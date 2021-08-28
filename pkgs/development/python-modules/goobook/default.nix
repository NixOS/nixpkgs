{ lib, buildPythonPackage, fetchPypi, isPy3k
, docutils, installShellFiles
, google-api-python-client, simplejson, oauth2client, setuptools, xdg
}:

buildPythonPackage rec {
  pname = "goobook";
  version = "3.5.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e69aeaf69112d116302f0c42ca1904f3b6efd17f15cefc12c866206160293be";
  };

  nativeBuildInputs = [ docutils installShellFiles ];
  propagatedBuildInputs = [
    google-api-python-client simplejson oauth2client setuptools xdg
  ];

  postInstall = ''
    rst2man goobook.1.rst goobook.1
    installManPage goobook.1
  '';

  doCheck = false;

  pythonImportsCheck = [ "goobook" ];

  meta = with lib; {
    description = "Access your Google contacts from the command line";
    longDescription = ''
      The purpose of GooBook is to make it possible to use your Google Contacts
      from the command-line and from MUAs such as Mutt.
      It can be used from Mutt the same way as abook.
    '';
    homepage    = "https://pypi.python.org/pypi/goobook";
    changelog   = "https://gitlab.com/goobook/goobook/-/blob/${version}/CHANGES.rst";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ primeos ];
    platforms   = platforms.unix;
  };
}
