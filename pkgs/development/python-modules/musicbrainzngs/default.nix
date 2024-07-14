{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkgs,
}:

buildPythonPackage rec {
  pname = "musicbrainzngs";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qxwBAP0LMFhS5l8u1BE8beEuaK/VUYaYe47Zfg+Y5ic=";
  };

  buildInputs = [ pkgs.glibcLocales ];

  LC_ALL = "en_US.UTF-8";

  preCheck = ''
    # Remove tests that rely on networking (breaks sandboxed builds)
    rm test/test_submit.py
  '';

  meta = with lib; {
    homepage = "https://python-musicbrainzngs.readthedocs.org/";
    description = "Python bindings for musicbrainz NGS webservice";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
