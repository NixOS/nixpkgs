{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "musicbrainzngs";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dddarpjawryll2wss65xq3v9q8ln8dan7984l5dxzqx88d2dvr8";
  };

  buildInputs = [ pkgs.glibcLocales ];

  LC_ALL="en_US.UTF-8";

  preCheck = ''
    # Remove tests that rely on networking (breaks sandboxed builds)
    rm test/test_submit.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://python-musicbrainzngs.readthedocs.org/";
    description = "Python bindings for musicbrainz NGS webservice";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
