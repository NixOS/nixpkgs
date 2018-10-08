{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyinotify";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c998a5d7606ca835065cdabc013ae6c66eb9ea76a00a1e3bc6e0cfe2b4f71f4";
  };

  # No tests distributed
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/seb-m/pyinotify/wiki;
    description = "Monitor filesystems events on Linux platforms with inotify";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.costrouc ];
  };
}
