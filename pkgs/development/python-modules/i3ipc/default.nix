{ stdenv, buildPythonPackage, fetchFromGitHub
, xorgserver, pytest, pytest-xvfb, pytest-asyncio, i3, python, xlib, xdpyinfo
, makeFontsConf, coreutils
}:

buildPythonPackage rec {
  pname = "i3ipc";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner  = "acrisci";
    repo   = "i3ipc-python";
    rev    = "v${version}";
    sha256 = "13bzs9dcv27czpnnbgz7a037lm8h991c8gk0qzzk5mq5yak24715";
  };
  propagatedBuildInputs = [ xlib ];

  fontsConf = makeFontsConf {
    fontDirectories = [ ];
  };
  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file
  checkInputs = [ pytest xdpyinfo pytest-asyncio pytest-xvfb xorgserver i3 ];

  postPatch = ''
    substituteInPlace test/i3.config \
      --replace /bin/true ${coreutils}/bin/true
  '';

  checkPhase = ''
    py.test --ignore=test/aio/test_shutdown_event.py \
            --ignore=test/test_shutdown_event.py
  '';


  meta = with stdenv.lib; {
    description = "An improved Python library to control i3wm and sway";
    homepage    = "https://github.com/acrisci/i3ipc-python";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ vanzef ];
  };
}
