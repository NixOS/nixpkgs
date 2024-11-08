{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "python-unshare";
  # pypi version doesn't support Python 3 and the package didn't update for a long time:
  # https://github.com/TheTincho/python-unshare/pull/8
  version = "unstable-2018-05-20";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "TheTincho";
    repo = "python-unshare";
    rev = "4e98c177bdeb24c5dcfcd66c457845a776bbb75c";
    sha256 = "1h9biinhy5m7r2cj4abhvsg2hb6xjny3n2dxnj1336zpa082ys3h";
  };

  meta = with lib; {
    description = "Python bindings for the Linux unshare() syscall";
    homepage = "https://github.com/thetincho/python-unshare";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
