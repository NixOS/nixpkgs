{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, requests
, process-tests
}:

buildPythonPackage rec {
  pname = "manhole";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4ab98198481ed54a5b95c0439f41131f56d7d3755eedaedce5a45ca7ff4aa42";
  };

  # test_help expects architecture-dependent Linux signal numbers.
  #
  # {test_locals,test_socket_path} fail to remove /tmp/manhole-socket
  # on the x86_64-darwin builder.
  #
  # TODO: change this back to `doCheck = stdenv.isLinux` after
  # https://github.com/ionelmc/python-manhole/issues/54 is fixed
  doCheck = false;

  checkInputs = [ pytest requests process-tests ];
  checkPhase = ''
    # Based on its tox.ini
    export PYTHONUNBUFFERED=yes
    export PYTHONPATH=.:tests:$PYTHONPATH

    # The tests use manhole-cli
    export PATH="$PATH:$out/bin"

    # test_uwsgi fails with:
    # http.client.RemoteDisconnected: Remote end closed connection without response
    py.test -vv -k "not test_uwsgi"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/ionelmc/python-manhole";
    description = "Debugging manhole for Python applications";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ivan ];
  };
}
