{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, docutils, installShellFiles
, google_api_python_client, simplejson, oauth2client, setuptools, xdg
}:

buildPythonPackage rec {
  pname = "goobook";
  version = "3.5";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rmfyma3gwdf5mrw4l3j66y86fy8hgdbd0z4a5kck0kcm3hy34j9";
  };

  nativeBuildInputs = [ docutils installShellFiles ];
  propagatedBuildInputs = [
    google_api_python_client simplejson oauth2client setuptools xdg
  ];

  postInstall = ''
    rst2man goobook.1.rst goobook.1
    installManPage goobook.1
  '';

  meta = with stdenv.lib; {
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
