{ lib, buildPythonPackage, fetchPypi, isPy3k
, docutils, installShellFiles
, google-api-python-client, simplejson, oauth2client, setuptools, xdg
}:

buildPythonPackage rec {
  pname = "goobook";
  version = "3.5.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i24Hh10iXFUiWVgokMs7f8ZpIVN/ZEF421tfa2ByQ4c=";
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
