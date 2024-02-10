{ lib
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "musicbrainzngs";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09z6k07pxncfgfc8clfmmxl2xqbd7h8x8bjzwr95hc0bzl00275b";
  };

  buildInputs = [ pkgs.glibcLocales ];

  LC_ALL="en_US.UTF-8";

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
