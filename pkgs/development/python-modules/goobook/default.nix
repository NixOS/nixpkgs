{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder
, docutils
, installShellFiles
, poetry-core
, google-api-python-client
, simplejson
, oauth2client
, setuptools
, pyxdg
}:

buildPythonPackage rec {
  pname = "goobook";
  version = "3.5.2";

  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "goobook";
    repo = "goobook";
    rev = version;
    hash = "sha256-gWmeRlte+lP7VP9gbPuMHwhVkx91wQ0GpQFQRLJ29h8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools = "^62.6.0"' 'setuptools = "*"' \
      --replace 'google-api-python-client = "^1.7.12"' 'google-api-python-client = "*"' \
      --replace 'pyxdg = "^0.28"' 'pyxdg = "*"'
  '';

  nativeBuildInputs = [
    docutils
    installShellFiles
    poetry-core
  ];

  propagatedBuildInputs = [
    google-api-python-client
    simplejson
    oauth2client
    setuptools
    pyxdg
  ];

  postInstall = ''
    rst2man goobook.1.rst goobook.1
    installManPage goobook.1
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "goobook" ];

  meta = with lib; {
    description = "Access your Google contacts from the command line";
    longDescription = ''
      The purpose of GooBook is to make it possible to use your Google Contacts
      from the command-line and from MUAs such as Mutt.
      It can be used from Mutt the same way as abook.
    '';
    homepage = "https://pypi.org/project/goobook/";
    changelog = "https://gitlab.com/goobook/goobook/-/blob/${version}/CHANGES.rst";
    license = licenses.gpl3;
    maintainers = with maintainers; [ primeos ];
  };
}
