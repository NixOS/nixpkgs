{ stdenv, buildPythonPackage, fetchPypi
, pep8, coverage, logilab_common, requests }:

buildPythonPackage rec {
  pname = "bugzilla";
  version = "2.2.0";

  src = fetchPypi {
    pname = "python-${pname}";
    inherit version;
    sha256 = "0x3jjb1g5bgjdj0jf0jmcg80hn5x2isf49frwvf2ykdl3fxd5gxc";
  };

  buildInputs = [ pep8 coverage logilab_common ];
  propagatedBuildInputs = [ requests ];

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/python-bugzilla/python-bugzilla;
    description = "Bugzilla XMLRPC access module";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron peti ];
  };
}
