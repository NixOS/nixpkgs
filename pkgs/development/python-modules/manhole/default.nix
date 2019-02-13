{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, requests
, process-tests
}:

buildPythonPackage rec {
  pname = "manhole";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ivy8qiv87jl2lc1ldhv9dc4jwf3hz7wysdfiagdcd9kkd48v8m";
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
    homepage = https://github.com/ionelmc/python-manhole;
    description = "Debugging manhole for Python applications";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ivan ];
  };
}
