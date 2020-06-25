# Python3 should be used, because
# "GitPython-3.1.0 not supported for interpreter python2.7"
{ python3, lib }:

python3.pkgs.buildPythonApplication rec {
  pname = "gertty";
  version = "1.6.0";

  buildInputs = with python3.pkgs; [
    pbr
    voluptuous
    dateutil
    requests
    urwid
    ply
    ordereddict
    alembic
    GitPython
    pyyaml
  ];

  propagatedBuildInputs = buildInputs;
  
  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1pvpca59z5rcir7lz2yimwiqjvd8yhnwjskxna2bslyfwv996d8w";
  };

  # It uses tox, and tox tries to create a virtualenv and download
  # flake8. Moreover, it looks like there are not really tests.
  doCheck = false;

  meta = {
    homepage = "http://ttygroup.org/gertty/index.html";
    description = "Gertty is a console-based interface to the Gerrit Code Review system.";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dav1d23 ];
  };
}
